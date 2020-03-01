<?php

/**
 * 充值记录
 */
namespace Admin\Controller;
use Common\Controller\AdminbaseController;
class ChargeController extends AdminbaseController {
    var $status=array("0"=>"未支付","1"=>"已完成");
    var $type=array("1"=>"支付宝","2"=>"微信","3"=>"苹果支付");
    var $ambient=array(
            "1"=>array(
                '0'=>'App',
                '1'=>'PC',
            ),
            "2"=>array(
                '0'=>'App',
                '1'=>'公众号',
                '2'=>'PC',
            ),
            "3"=>array(
                '0'=>'沙盒',
                '1'=>'生产',
            )
        );
    function index(){
        $adminid=$_SESSION['ADMIN_ID'];
        $role_id=$_SESSION['role_id'];
        $isshowset=1;
        if(!sp_auth_check($adminid,'admin/charge/setpay')){
            $isshowset=0;
        }
        $this->assign('isshowset', $isshowset);
        
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
        
        if($_REQUEST['status']!=''){
            $map['status']=$_REQUEST['status'];
            $_GET['status']=$_REQUEST['status'];
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

        if($_REQUEST['keyword']!=''){
            $map['uid|orderno|trade_no']=array("like","%".$_REQUEST['keyword']."%"); 
            $_GET['keyword']=$_REQUEST['keyword'];
        }

    	$charge=M("users_charge");
    	$count=$charge->where($map)->count();
    	$page = $this->page($count, 20);
    	$lists = $charge
    	->where($map)
    	->order("addtime DESC")
    	->limit($page->firstRow . ',' . $page->listRows)
    	->select();
		
		$moneysum = $charge
					->where($map)
					->sum("money");	
					
			foreach($lists as $k=>$v){
				   $userinfo=M("users")->field("user_nicename")->where("id='$v[uid]'")->find();
				   $lists[$k]['userinfo']= $userinfo;
					 
			}
            
    	
    	$this->assign('moneysum', $moneysum);
    	$this->assign('lists', $lists);
    	$this->assign('formget', $_GET);
    	$this->assign("page", $page->show('Admin'));
        
        $this->assign('status', $this->status);
        $this->assign('type', $this->type);
        $this->assign('ambient', $this->ambient);
    	
    	$this->display();
    }
    
    function setPay(){
        $id=intval($_GET['id']);
        if($id){
            $result=M("users_charge")->where("id={$id} and status=0")->find();				
            if($result){
                
                /* 更新会员虚拟币 */
                $coin=$result['coin']+$result['coin_give'];
                M("users")->where("id='{$result['touid']}'")->setInc("coin",$coin);
                /* 更新 订单状态 */
                M("users_charge")->where("id='{$result['id']}'")->save(array("status"=>1));
                    
                $action="确认充值：{$id}";
                setAdminLog($action);
                $this->success('操作成功');
             }else{
                $this->error('数据传入失败！');
             }			
        }else{				
            $this->error('数据传入失败！');
        }								          
    }
		
		function del(){
            $id=intval($_GET['id']);
            if($id){
                $result=M("users_charge")->delete($id);				
                if($result){
                    $action="删除充值记录：{$id}";
                    setAdminLog($action);
                    $this->success('删除成功');
                }else{
                    $this->error('删除失败');
                }			
            }else{				
                $this->error('数据传入失败！');
            }								  
            $this->display();				
		}
		function export()
		{
			if($_REQUEST['status']!=''){
					$map['status']=$_REQUEST['status'];
				}
				if($_REQUEST['start_time']!=''){
					$map['addtime']=array("gt",strtotime($_REQUEST['start_time']));
				}			 
				if($_REQUEST['end_time']!=''){	 
					$map['addtime']=array("lt",strtotime($_REQUEST['end_time']));
				}
				if($_REQUEST['start_time']!='' && $_REQUEST['end_time']!='' ){	 
					$map['addtime']=array("between",array(strtotime($_REQUEST['start_time']),strtotime($_REQUEST['end_time'])));
				}
				if($_REQUEST['keyword']!=''){
					$map['uid|orderno|trade_no']=array("like","%".$_REQUEST['keyword']."%"); 
				}
                $xlsName  = "Excel";
				$charge=M("users_charge");
				$xlsData=$charge->where($map)->Field('id,uid,money,coin,coin_give,orderno,type,trade_no,status,addtime')->order("addtime DESC")->select();
                foreach ($xlsData as $k => $v)
                {
                    $userinfo=M("users")->field("user_nicename")->where("id='$v[uid]'")->find();
                    $xlsData[$k]['user_nicename']= $userinfo['user_nicename']."(".$v['uid'].")";
                    $xlsData[$k]['addtime']=date("Y-m-d H:i:s",$v['addtime']); 
                    $xlsData[$k]['type']=$this->type[$v['type']];
                    $xlsData[$k]['status']=$this->status[$v['status']];
                    //if($v['type']=='1'){ $xlsData[$k]['type']="支付宝";}else if( $xlsData[$k]['type']=='2'){ $xlsData[$k]['type']="微信";}else{ $xlsData[$k]['type']="苹果支付";}
                    //if($v['status']=='0'){ $xlsData[$k]['status']="未支付";}else{ $xlsData[$k]['status']="已完成";} 
                }
        
                $action="导出充值记录：".M("users_charge")->getLastSql();
                setAdminLog($action);
				$cellName = array('A','B','C','D','E','F','G','H','I','J');
				$xlsCell  = array(
                    array('id','序号'),
                    array('user_nicename','会员'),
                    array('money','人民币金额'),
                    array('coin','兑换点数'),
                    array('coin_give','赠送点数'),
                    array('orderno','商户订单号'),
                    array('type','支付类型'),
                    array('trade_no','第三方支付订单号'),
                    array('status','订单状态'),
                    array('addtime','提交时间')
                );
                exportExcel($xlsName,$xlsCell,$xlsData,$cellName);
		}

}
