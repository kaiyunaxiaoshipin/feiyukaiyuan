<?php

/**
 * 消费记录
 */
namespace Admin\Controller;
use Common\Controller\AdminbaseController;
class CoinrecordController extends AdminbaseController {
    function index(){
        $adminid=$_SESSION['ADMIN_ID'];
        $role_id=$_SESSION['role_id'];

        $Proxy=M('users_proxy');
        
        /* 代理业务员 */
        
        $showlevel='0';
        if($role_id==6){
            $showlevel='1';
            
            $where['u.user_type']='1';
            $where['r.role_id']='7';
            $path=setpath($adminid);
            $uids=$Proxy->where("type=-1 and path like '%{$path}%'")->getField('uid',true);
            if(!$uids){
                $uids=[];
                array_push($uids,'0');
            }
            $where['u.id']  = array('in',$uids);
            
            $promoterlist=M('users u')
                ->join('__ROLE_USER__ r ON r.user_id = u.id')
                ->field('u.id,u.user_login,user_nicename')
                ->where($where)
                ->order("u.create_time DESC")
                ->select();
            foreach($promoterlist as $k=>$v){
                if($v['user_nicename']==''){
                    $v['user_nicename']=$v['user_login'];
                }
                $promoterlist[$k]=$v;
            }
        }else if($role_id==7){
            $showlevel='2';
        }else{
            
            $where['u.user_type']='1';
            $where['r.role_id']='6';
            $proxylistj=[];
            $proxylist=M('users u')
                ->join('__ROLE_USER__ r ON r.user_id = u.id')
                ->field('u.id,u.user_login,u.user_nicename')
                ->where($where)
                ->order("u.create_time DESC")
                ->select();
            foreach($proxylist as $k=>$v){
                if($v['user_nicename']==''){
                    $v['user_nicename']=$v['user_login'];
                }
                $where2['user_type']='1';
                $path=setpath($v['id']);
                $uids=$Proxy->where("type=-1 and path like '%{$path}%'")->getField('uid',true);
                if(!$uids){
                    $uids=[];
                    array_push($uids,'0');
                }

                $where2['id']  = array('in',$uids);
                $promoterlistj=[];
                $promoterlist2=M('users')
                    ->field('id,user_login,user_nicename')
                    ->where($where2)
                    ->order("create_time DESC")
                    ->select();
                foreach($promoterlist2 as $k2=>$v2){
                    if($v2['user_nicename']==''){
                        $v2['user_nicename']=$v2['user_login'];
                    }
                    $promoterlistj[$v2['id']]=$v2;
                }
                $v['list']=$promoterlistj;
                $proxylistj[$v['id']]=$v;
            }   
        }
        
        $this->assign('proxylistj', json_encode($proxylistj));
    	$this->assign('promoterlist', $promoterlist);
    	$this->assign('showlevel', $showlevel);
        
        if($role_id==6 || $role_id==7 || $_REQUEST['proxyid']!='' || $_REQUEST['promoterid']!=''){
            
            if($_REQUEST['proxyid']!=''){
                $adminid=$_REQUEST['proxyid'];
                 $_GET['proxyid']=$_REQUEST['proxyid'];
            }
            
            if($_REQUEST['promoterid']!=''){
                $adminid=$_REQUEST['promoterid'];
                $_GET['promoterid']=$_REQUEST['promoterid'];
            }
            
            $path=setpath($adminid);
            $uids=$Proxy->where("type=0 and path like '%{$path}%'")->getField('uid',true);
            if(!$uids){
                $uids=[];
                array_push($uids,'0');
            }
            $map['uid']  = array('in',$uids);
        }
        if($_REQUEST['type']!=''){
              $map['type']=$_REQUEST['type'];
                $_GET['type']=$_REQUEST['type'];
         }
         
         if($_REQUEST['action']!=''){
              $map['action']=$_REQUEST['action'];
                $_GET['action']=$_REQUEST['action'];
         }
         
       if($_REQUEST['start_time']!=''){
              $map['addtime']=array("gt",strtotime($_REQUEST['start_time']));
                $_GET['start_time']=$_REQUEST['start_time'];
         }
         
         if($_REQUEST['end_time']!=''){
             
               $map['addtime']=array("lt",strtotime($_REQUEST['end_time']));
                 $_GET['end_time']=$_REQUEST['end_time'];
         }
         if($_REQUEST['start_time']!='' && $_REQUEST['end_time']!='' ){
             
             $map['addtime']=array("between",array(strtotime($_REQUEST['start_time']),strtotime($_REQUEST['end_time'])));
             $_GET['start_time']=$_REQUEST['start_time'];
             $_GET['end_time']=$_REQUEST['end_time'];
         }

         if($_REQUEST['uid']!=''){
             $map['uid']=$_REQUEST['uid']; 
             $_GET['uid']=$_REQUEST['uid'];
         }
          if($_REQUEST['touid']!=''){
             $map['touid']=$_REQUEST['touid']; 
             $_GET['touid']=$_REQUEST['touid'];
         }

			
    	$coin=M("users_coinrecord");
		$Users=M("users");
		$Game=M("game");
		$Gift=M("gift");
		$Vip=M("vip");
		$Car=M("car");
		$Liang=M("liang");
		$Guard=M("guard");
		$game_action=array(
			'0'=>'',
			'1'=>'智勇三张',
			'2'=>'海盗船长',
			'3'=>'转盘',
			'4'=>'开心牛仔',
			'5'=>'二八贝',
		);
		
    	$count=$coin->where($map)->count();
    	$page = $this->page($count, 20);
    	$lists = $coin
    	->where($map)
    	->order("addtime DESC")
    	->limit($page->firstRow . ',' . $page->listRows)
    	->select();
			
			foreach($lists as $k=>$v){
				$userinfo=$Users->field("user_nicename")->where("id='$v[uid]'")->find();
				$lists[$k]['userinfo']= $userinfo;
				$touserinfo=$Users->field("user_nicename")->where("id='$v[touid]'")->find();
				$lists[$k]['touserinfo']= $touserinfo;
				$action=$v['action'];
				if($action=='sendgift'){
					$giftinfo=$Gift->field("giftname")->where("id='$v[giftid]'")->find();
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='loginbonus'){
					$giftinfo['giftname']='第'.$v['giftid'].'天';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='sendbarrage'){
					$giftinfo['giftname']='弹幕';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='game_bet' || $action=='game_return' || $action=='game_win' || $action=='game_brokerage' || $action=='game_banker'){
					$info=$Game->field('action')->where("id={$v['giftid']}")->find();
					$giftinfo['giftname']=$game_action[$info['action']];
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='set_deposit'){
					$giftinfo['giftname']='上庄扣除';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='deposit_return'){
					$giftinfo['giftname']='下庄退还';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='roomcharge'){
					$giftinfo['giftname']='房间扣费';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='timecharge'){
					$giftinfo['giftname']='计时扣费';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='buyvip'){
					$info=$Vip->field("name")->where("id='{$v[giftid]}'")->find();
					$giftinfo['giftname']=$info['name'];
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='buycar'){
					$info=$Car->field("name")->where("id='{$v[giftid]}'")->find();
					$giftinfo['giftname']=$info['name'];
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='buyliang'){
					$info=$Liang->field("name")->where("id='{$v[giftid]}'")->find();
					$giftinfo['giftname']=$info['name'];
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='sendred'){
					$giftinfo['giftname']='发送红包';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='robred'){
					$giftinfo['giftname']='抢红包';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='buyguard'){
                    $info=$Guard->field("name")->where("id='{$v[giftid]}'")->find();
					$giftinfo['giftname']=$info['name'];
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='reg_reward'){
					$giftinfo['giftname']='注册奖励';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='luckgift'){
					$giftinfo['giftname']='礼物中奖';
					$lists[$k]['giftinfo']= $giftinfo;
				}else if($action=='jackpotwin'){
					$giftinfo['giftname']='奖池中奖';
					$lists[$k]['giftinfo']= $giftinfo;
				}else{
					$giftinfo['giftname']='未知';
					$lists[$k]['giftinfo']= $giftinfo;
				}
				
					 
			}
			
    	$this->assign('lists', $lists);
    	$this->assign('formget', $_GET);
    	$this->assign("page", $page->show('Admin'));
    	
    	$this->display();
    }
		
		function del(){
			 	$id=intval($_GET['id']);
					if($id){
						$result=M("users_coinrecord")->delete($id);				
							if($result){
									$this->success('删除成功');
							 }else{
									$this->error('删除失败');
							 }			
					}else{				
						$this->error('数据传入失败！');
					}								  
					$this->display();				
		}		

    	
}
