<?php
/**
 * 注册页面
 */
namespace Appapi\Controller;
use Common\Controller\HomebaseController;
class RegController extends HomebaseController {

	function index(){
        $agentid = checkNull(I("agentid"));
        
        if($agentid){
            $agentuid=M('users')->where("user_type=1 and user_activation_key='{$agentid}'")->getField('id');
            if(!$agentuid){
                $this->assign("reason",'邀请码不正确');
                $this->display(':error');
                exit;
            }
        }
        
        $this->assign('agentid',$agentid);
		$this->display();
	}

    /* 微信登录 */
	public function wxLogin(){
		$agentid=checkNull(I('agentid'));
		$configpri=getConfigPri();
		
		$AppID = $configpri['login_wx_appid'];
		$callback  = get_upload_path('/Appapi/Reg/wxLoginCallback?agentid='.$agentid); //回调地址
		//微信登录
		session_start();
		//-------生成唯一随机串防CSRF攻击
		$state  = md5(uniqid(rand(), TRUE));
		$_SESSION["wx_state"]    = $state; //存到SESSION
		$callback = urlencode($callback);
		//snsapi_base 静默  snsapi_userinfo 授权
		$wxurl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid={$AppID}&redirect_uri={$callback}&response_type=code&scope=snsapi_userinfo&state={$state}#wechat_redirect ";
		
		header("Location: $wxurl");
	}
	
	public function wxLoginCallback(){
		$code=I('code');
		$agentid=checkNull(I('agentid'));
		if($code){
			$configpri=getConfigPri();
		
			$AppID = $configpri['login_wx_appid'];
			$AppSecret = $configpri['login_wx_appsecret'];
			/* 获取token */
			$url="https://api.weixin.qq.com/sns/oauth2/access_token?appid={$AppID}&secret={$AppSecret}&code={$code}&grant_type=authorization_code";
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
			curl_setopt($ch, CURLOPT_URL, $url);
			$json =  curl_exec($ch);
			curl_close($ch);
			$arr=json_decode($json,1);
            
            if(isset($arr['errcode'])){
                $this->assign("reason",$arr['errmsg']);
                $this->display(':error');
                exit;
            }
            
			/* 刷新token 有效期为30天 */
			$url="https://api.weixin.qq.com/sns/oauth2/refresh_token?appid={$AppID}&grant_type=refresh_token&refresh_token={$arr['refresh_token']}";
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
			curl_setopt($ch, CURLOPT_URL, $url);
			$json =  curl_exec($ch);
			curl_close($ch);
			
			$url="https://api.weixin.qq.com/sns/userinfo?access_token={$arr['access_token']}&openid={$arr['openid']}&lang=zh_CN";
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
			curl_setopt($ch, CURLOPT_URL, $url);
			$json =  curl_exec($ch);
			curl_close($ch);
			$wxuser=json_decode($json,1);

			/* 公众号绑定到 开放平台 才有 unionid  否则 用 openid  */
			$openid=$wxuser['unionid'];
			if(!$openid){
                $this->assign("reason",'公众号未绑定到开放平台');
                $this->display(':error');
                exit;
			}
			$User=M('users');
		
			$userinfo=$User->field("id")->where("openid!='' and openid='{$openid}'")->find();

			if(empty($userinfo)){
				if($openid!=""){
					$pass='123456';
					$user_pass=setPass($pass);
                    
                    if($agentid!=''){
                        $agentuid=M('users')->where("user_type=1 and user_activation_key='{$agentid}'")->getField('id');
                        if(!$agentuid){
                            $this->assign("reason",'邀请码不正确');
                            $this->display(':error');
                            exit;
                        }  
                    }
					
					$data=array(
						'openid' 	=>$openid,
						'user_login'	=> "wx_".time().substr($openid,-4), 
						'user_pass'		=>$user_pass,
						'user_nicename'	=> $wxuser['nickname'],
						'sex'=> $wxuser['sex'],
						'avatar'=> $wxuser['headimgurl'],
						'avatar_thumb'	=> $wxuser['headimgurl'],
						'login_type'=> "wx",
						'last_login_ip' =>$_SERVER['REMOTE_ADDR'],
						'create_time' => date("Y-m-d H:i:s"),
						'last_login_time' => date("Y-m-d H:i:s"),
						'user_status' => 1,
						"user_type"=>2,//会员
						'signature' =>'这家伙很懒，什么都没留下',
					);	
					$userid=$User->add($data);
                    
                    
                    if($agentuid){
                        $Proxy=M('users_proxy');
                        $agentinfo=$Proxy->where("uid={$agentuid}")->find();
                        if($agentinfo){
                            $path=$agentinfo['path'].setpath($agentuid);
                            
                            $data2=[
                                'uid'=>$userid,
                                'path'=>$path,
                                'addtime'=>time(),
                            ];
                            $Proxy->add($data2);
                        }
                    }

				}
			} 

			$href=get_upload_path('/index.php?g=Appapi&m=down&a=index');
			
		 	header("Location: $href");
			
		}
	}
    
    /* 手机登录 */
    /* 手机验证码 */
	public function getCode(){
		
        $rs = array('code' => 0, 'msg' => '发送成功，请注意查收', 'info' => array());
        
		$limit = ip_limit();	
		if( $limit == 1){
            $rs['code']=1003;
			$rs['msg']='您已当日发送次数过多';
			$this->ajaxReturn($rs);
		}
        
        $mobile = checkNull(I("mobile"));
        $ismobile=checkMobile($mobile);
		if(!$ismobile){
			$rs['code']=1001;
			$rs['msg']='请输入正确的手机号';
			$this->ajaxReturn($rs);
		}
        
        $where="user_login='{$mobile}'";
        
		$checkuser = checkUser($where);	
        
        if($checkuser){
            $rs['code']=1004;
			$rs['msg']='该手机号已注册，请登录';
			$this->ajaxReturn($rs);
        }

		if($_SESSION['reg_mobile']==$mobile && $_SESSION['reg_mobile_expiretime']> time() ){
			$rs['code']=1002;
			$rs['msg']='验证码5分钟有效，请勿多次发送';
			$this->ajaxReturn($rs);
		}
		
		$mobile_code = random(6,1);

		//密码可以使用明文密码或使用32位MD5加密
		$result = sendCode($mobile,$mobile_code); 
		if($result['code']===0){
			$_SESSION['reg_mobile'] = $mobile;
			$_SESSION['reg_mobile_code'] = $mobile_code;
			$_SESSION['reg_mobile_expiretime'] = time() +60*5;	
		}else if($result['code']==667){
			$_SESSION['reg_mobile'] = $mobile;
            $_SESSION['reg_mobile_code'] = $result['msg'];
            $_SESSION['reg_mobile_expiretime'] = time() +60*5;
            
            $rs['code']=1002;
			$rs['msg']='验证码为：'.$result['msg'];
		}else{
			$rs['code']=1002;
			$rs['msg']=$result['msg'];
		} 

		$this->ajaxReturn($rs);
	}
    
    public function register(){
        $rs = array('code' => 0, 'msg' => '注册成功', 'info' => array());
        
        $userlogin = checkNull(I("userlogin"));
        $usercode = checkNull(I("usercode"));
        $userpass = checkNull(I("userpass"));
        $userpass2 = checkNull(I("userpass2"));
        $agentid = checkNull(I("agentid"));
        
        if(!$_SESSION['reg_mobile'] || !$_SESSION['reg_mobile_code']){
            $rs['code'] = 1001;
            $rs['msg'] = '请先获取验证码';
            $this->ajaxReturn($rs);		
        }
        
        if($userlogin==''){
            $rs['code']=1002;
			$rs['msg']='请输入您的手机号';
			$this->ajaxReturn($rs);
        }
        if($usercode==''){
            $rs['code']=1002;
			$rs['msg']='请输入验证码';
			$this->ajaxReturn($rs);
        }
        if($userpass==''){
            $rs['code']=1002;
			$rs['msg']='请输入密码';
			$this->ajaxReturn($rs);
        }
        if($userpass2==''){
            $rs['code']=1002;
			$rs['msg']='请输入确认密码';
			$this->ajaxReturn($rs);
        }
        
        if($userlogin!=$_SESSION['reg_mobile']){
            $rs['code'] = 1001;
            $rs['msg'] = '手机号码不一致';
            $this->ajaxReturn($rs);
		}
        
        if($usercode!=$_SESSION['reg_mobile_code']){
            $rs['code'] = 1002;
            $rs['msg'] = '验证码错误';
            $this->ajaxReturn($rs);
		}	
        
		$check = passcheck($userpass);

		if($check==0){
            $rs['code'] = 1004;
            $rs['msg'] = '密码6-12位数字与字母';
            $this->ajaxReturn($rs);							
        }else if($check==2){
            $rs['code'] = 1005;
            $rs['msg'] = '密码不能纯数字或纯字母';
            $this->ajaxReturn($rs);						
        }	
        
        if($userpass!=$userpass2){
            $rs['code']=1006;
			$rs['msg']='密码和确认密码不一致';
			$this->ajaxReturn($rs);
        }
        if($agentid){
            $agentuid=M('users')->where("user_type=1 and user_activation_key='{$agentid}'")->getField('id');
            if(!$agentuid){
                $rs['code']=1007;
                $rs['msg']='邀请码不正确';
                $this->ajaxReturn($rs);
            }
        }
		$User=M("users");
		
		$ifreg=$User->field("id")->where("user_login='{$userlogin}'")->find();
		if($ifreg){
            $rs['code']=1008;
			$rs['msg']='该账号已被注册';
			$this->ajaxReturn($rs);
		}
		
        $userpass=setPass($userpass);
        
		/* 无信息 进行注册 */
		$configPri=getConfigPri();
		$data=array(
				'user_login' => $userlogin,
				'user_email' => '',
				'mobile' =>$userlogin,
				'user_nicename' =>'WEB用户'.substr($userlogin,-4),
				'user_pass' =>$userpass,
				'signature' =>'这家伙很懒，什么都没留下',
				'avatar' =>'/default.jpg',
				'avatar_thumb' =>'/default_thumb.jpg',
				'last_login_ip' =>get_client_ip(),
				'create_time' => date("Y-m-d H:i:s"),
				'user_status' => 1,
				"user_type"=>2,//会员
		);

		if($configPri['reg_reward']>0){

			$data['coin']=$configPri['reg_reward'];
		}

		$userid=$User->add($data);        
        if(!$userid){
            $rs['code']=1009;
			$rs['msg']='注册失败，请重试';
			$this->ajaxReturn($rs);
        }
        
        if($agentuid){
            $Proxy=M('users_proxy');
            $agentinfo=$Proxy->where("uid={$agentuid}")->find();
            if($agentinfo){
                $path=$agentinfo['path'].setpath($agentuid);
                
                $data2=[
                    'uid'=>$userid,
                    'path'=>$path,
                    'addtime'=>time(),
                ];
                $Proxy->add($data2);
            }
        }
        
        $this->ajaxReturn($rs);
    }
    
}