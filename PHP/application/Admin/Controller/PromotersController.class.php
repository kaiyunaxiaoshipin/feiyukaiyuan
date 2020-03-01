<?php
/* 推广员管理 */
namespace Admin\Controller;
use Common\Controller\AdminbaseController;
class PromotersController extends AdminbaseController{
	protected $users_model,$role_model;
	
	function _initialize() {
		parent::_initialize();
		$this->users_model = D("Common/Users");
		$this->role_model = D("Common/Role");
	}
	function index(){
        $where=[];
        $where['user_type']='1';
        
        if($_REQUEST['keyword']!=''){
            $where['user_login|user_nicename']=array("like","%{$_REQUEST['keyword']}%");
            $_GET['keyword']=$_REQUEST['keyword'];
        }
        
        
        $admin_roleid=$_SESSION['role_id'];
        $isshow=0;
        if($admin_roleid!=6){
            $isshow=1;
        }
        $this->assign("isshow",$isshow);
        
        $adminid=$_SESSION['ADMIN_ID'];
        $one_id=$adminid;
        if($_REQUEST['one_id']!=''){
            $one_id=$_REQUEST['one_id'];
            $_GET['one_id']=$_REQUEST['one_id'];
        }

        $Proxy=M('users_proxy');
        $where2="type=-1";
        if($admin_roleid==6 || $_REQUEST['one_id']!=''){
            $path=setpath($one_id);
            
            $where2.=" and path like '%{$path}%'";
        }
        $uids=$Proxy->where($where2)->getField('uid',true);
        if(!$uids){
            $uids=[];
            array_push($uids,'0');
        }
        $where['id']  = array('in',$uids);
        /* 推广员列表 */
		$count=M('users u')->where($where)->count();
		$page = $this->page($count, 20);
		$users = M('users u')
            ->field('*')
            ->where($where)
            ->order("create_time DESC")
            ->limit($page->firstRow . ',' . $page->listRows)
            ->select();

        $Charge=M('users_charge');
        $Votes=M('users_voterecord');
        $User=M('users');
        foreach($users as $k=>$v){
            $path=setpath($v['id']);
            $uids=$Proxy->where("type = 0 and path like '%{$path}%'")->getField('uid',true);
            if(!$uids){
                $uids=[];
                array_push($uids,'0');
            }

            $map=[];
            $map['uid']  = array('in',$uids);
            $total_charge=$Charge->where("status=1")->where($map)->sum('money');
            if(!$total_charge){
                $total_charge='0';
            }
            $v['total_charge']=$total_charge;
            
            $map2=[];
            $map2['id']  = array('in',$uids);
            $total_coin=$User->where("user_type=2")->where($map2)->sum('consumption');
            if(!$total_coin){
                $total_coin='0';
            }
            $v['total_coin']=$total_coin;
            
            $map3=[];
            $map3['uid']  = array('in',$uids);
            $total_votes=$Votes->where("type='income'")->where($map3)->sum('votes');
            if(!$total_votes){
                $total_votes='0';
            }
            $v['total_votes']=$total_votes;
            
            $users[$k]=$v;
            
        }
        
        /* 代理商列表 */
        $where_p=[];
        $where_p['u.user_type']='1';
        $where_p['r.role_id']='6';
		$proxys = M('users u')
            ->join('__ROLE_USER__ r ON r.user_id = u.id')
            ->field('u.*')
            ->where($where_p)
            ->order("u.create_time DESC")
            ->select();
        foreach($proxys as $k=>$v){
            if($v['user_nicename']==''){
                $v['user_nicename']=$v['user_login'];
            }
            $proxys[$k]=$v;
        }
        $this->assign("proxys",$proxys);
        

        
		
        $this->assign('formget', $_GET);
		$this->assign("page", $page->show('Admin'));
		$this->assign("users",$users);
		$this->display();
	}
	
	
	function add(){
		
        $where=[];
        $where['u.user_type']='1';
        $where['r.role_id']='6';
		$proxys = M('users u')
            ->join('__ROLE_USER__ r ON r.user_id = u.id')
            ->field('u.*')
            ->where($where)
            ->order("u.create_time DESC")
            ->select();
        foreach($proxys as $k=>$v){
            if($v['user_nicename']==''){
                $v['user_nicename']=$v['user_login'];
            }
            $proxys[$k]=$v;
        }
        $this->assign("proxys",$proxys);
        
        $adminid=$_SESSION['ADMIN_ID'];
        $admin_roleid=$_SESSION['role_id'];
        $isshow=0;
        if($admin_roleid!=6){
            $isshow=1;
        }
        $this->assign("isshow",$isshow);
        
        $code=$this->createCode();
        
        $this->assign("code",$code);
        
		$this->display();
	}
	
	function add_post(){
		if(IS_POST){
			if(!empty($_POST['role_id']) && is_array($_POST['role_id'])){
				$role_ids=$_POST['role_id'];
				unset($_POST['role_id']);
                
                $adminid=$_SESSION['ADMIN_ID'];
                $admin_roleid=$_SESSION['role_id'];
                $one_id=$adminid;
                if($admin_roleid!=6){
                    $one_id=$_POST['one_id'];
                    if(!$one_id){
                        $this->error("请选择所属代理");
                    }
                    unset($_POST['one_id']);
                }
                
				if ($this->users_model->create()) {
					$result=$this->users_model->add();
					if ($result!==false) {
						$role_user_model=M("RoleUser");
						foreach ($role_ids as $role_id){
							$role_user_model->add(array("role_id"=>$role_id,"user_id"=>$result));
						}
                        $path=setpath($one_id);
                        $isexist=M('users_proxy')->where("uid={$one_id}")->find();
                        if($isexist){
                            $path=$isexist['path'].$path;
                        }
                        M('users_proxy')->add(array("uid"=>$result,"type"=>'-1',"path"=>$path,'addtime'=>time()));
                        
                        $action="添加推广员：{$result}";
                        setAdminLog($action);
						$this->success("添加成功！");
					} else {
						$this->error("添加失败！");
					}
				} else {
					$this->error($this->users_model->getError());
				}
			}else{
				$this->error("请为此用户指定角色！");
			}
			
		}
	}
	
	
	function edit(){
		$id= intval(I("get.id"));
        
        $where=[];
        $where['u.user_type']='1';
        $where['r.role_id']='6';
		$proxys = M('users u')
            ->join('__ROLE_USER__ r ON r.user_id = u.id')
            ->field('u.*')
            ->where($where)
            ->order("u.create_time DESC")
            ->select();
        foreach($proxys as $k=>$v){
            if($v['user_nicename']==''){
                $v['user_nicename']=$v['user_login'];
            }
            $proxys[$k]=$v;
        }
        $this->assign("proxys",$proxys);
        
        $adminid=$_SESSION['ADMIN_ID'];
        $admin_roleid=$_SESSION['role_id'];
        $isshow=0;
        if($admin_roleid!=6){
            $isshow=1;
        }
        $this->assign("isshow",$isshow);
        
        $proxyinfo=M('users_proxy')->where("uid={$id}")->find();
        $this->assign("proxyinfo",$proxyinfo);
			
		$user=$this->users_model->where(array("id"=>$id))->find();
		$this->assign($user);
		$this->display();
	}
	
	function edit_post(){
		if (IS_POST) {
			if(!empty($_POST['role_id']) && is_array($_POST['role_id'])){
				if(empty($_POST['user_pass'])){
					unset($_POST['user_pass']);
				}
				$role_ids=$_POST['role_id'];
				unset($_POST['role_id']);
                
                $adminid=$_SESSION['ADMIN_ID'];
                $admin_roleid=$_SESSION['role_id'];
                $one_id=$adminid;
                if($admin_roleid!=6){
                    $one_id=$_POST['one_id'];
                    if(!$one_id){
                        $this->error("请选择所属代理");
                    }
                    unset($_POST['one_id']);
                }
                
				if ($this->users_model->create()) {
					$result=$this->users_model->save();
					if ($result!==false) {
						$uid=intval($_POST['id']);
						$role_user_model=M("RoleUser");
						$role_user_model->where(array("user_id"=>$uid))->delete();
						foreach ($role_ids as $role_id){
							$role_user_model->add(array("role_id"=>$role_id,"user_id"=>$uid));
						}
                        
                        $path=setpath($one_id);
                        $isexist=M('users_proxy')->where("uid={$one_id}")->find();
                        if($isexist){
                            $path=$isexist['path'].$path;
                        }
                        
                        M('users_proxy')->where("uid={$uid}")->save( array("path"=>$path) );
                        
                        $action="编辑推广员：{$uid}";
                        setAdminLog($action);
						$this->success("保存成功！");
					} else {
						$this->error("保存失败！");
					}
				} else {
					$this->error($this->users_model->getError());
				}
			}else{
				$this->error("请为此用户指定角色！");
			}
			
		}
	}
	
	/**
	 *  删除
	 */
	function delete(){
		$id = intval(I("get.id"));
		if($id==1){
			$this->error("最高推广员不能删除！");
		}
		
		if ($this->users_model->where("id=$id")->delete()!==false) {
			M("RoleUser")->where(array("user_id"=>$id))->delete();
            $action="删除推广员：{$id}";
            setAdminLog($action);
			$this->success("删除成功！");
		} else {
			$this->error("删除失败！");
		}
	}

    function ban(){
        $id=intval($_GET['id']);
    	if ($id) {
    		$rst = $this->users_model->where(array("id"=>$id,"user_type"=>1))->setField('user_status','0');
    		if ($rst) {
                $action="停用推广员：{$id}";
                    setAdminLog($action);
    			$this->success("推广员停用成功！");
    		} else {
    			$this->error('推广员停用失败！');
    		}
    	} else {
    		$this->error('数据传入失败！');
    	}
    }
    
    function cancelban(){
    	$id=intval($_GET['id']);
    	if ($id) {
    		$rst = $this->users_model->where(array("id"=>$id,"user_type"=>1))->setField('user_status','1');
    		if ($rst) {
                $action="启用推广员：{$id}";
                    setAdminLog($action);
    			$this->success("推广员启用成功！");
    		} else {
    			$this->error('推广员启用失败！');
    		}
    	} else {
    		$this->error('数据传入失败！');
    	}
    }
	
	
    /* 生成邀请码 */
	function createCode($len=6,$format='ALL2'){
        $is_abc = $is_numer = 0;
        $password = $tmp =''; 
        switch($format){
            case 'ALL':
                $chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
                break;
            case 'ALL2':
                $chars='ABCDEFGHJKLMNPQRSTUVWXYZ0123456789';
                break;
            case 'CHAR':
                $chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
                break;
            case 'NUMBER':
                $chars='0123456789';
                break;
            default :
                $chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
                break;
        }
        
        while(strlen($password)<$len){
            $tmp =substr($chars,(mt_rand()%strlen($chars)),1);
            if(($is_numer <> 1 && is_numeric($tmp) && $tmp > 0 )|| $format == 'CHAR'){
                $is_numer = 1;
            }
            if(($is_abc <> 1 && preg_match('/[a-zA-Z]/',$tmp)) || $format == 'NUMBER'){
                $is_abc = 1;
            }
            $password.= $tmp;
        }
        if($is_numer <> 1 || $is_abc <> 1 || empty($password) ){
            $password = $this->createCode($len,$format);
        }
        if($password!=''){
            
            $oneinfo=M("users")->field("id")->where("user_activation_key='{$password}'")->find();
            if(!$oneinfo){
                return $password;
            }            
        }
        $password = $this->createCode($len,$format);
        return $password;
    }
	
}