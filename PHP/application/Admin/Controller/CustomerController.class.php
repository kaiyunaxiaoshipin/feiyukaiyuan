<?php
/* 客户管理 */
namespace Admin\Controller;
use Common\Controller\AdminbaseController;
class CustomerController extends AdminbaseController{

	function index(){
        $where=[];
        $where['user_type']='2';
        
        if($_REQUEST['keyword']!=''){
            $where['user_login|user_nicename']=array("like","%{$_REQUEST['keyword']}%");
            $_GET['keyword']=$_REQUEST['keyword'];
        }

        $admin_roleid=$_SESSION['role_id'];
        $isshow=0;
        if($admin_roleid!=7){
            $isshow=1;
        }
        $this->assign("isshow",$isshow);
        
        $adminid=$_SESSION['ADMIN_ID'];
        $one_id=$adminid;
        if($_REQUEST['one_id']!=''){
            $one_id=$_REQUEST['one_id'];
            $_GET['one_id']=$_REQUEST['one_id'];
        }
        $where2='type=0';
        $Proxy=M('users_proxy');
        if($admin_roleid==7 || $_REQUEST['one_id']!=''){
            $path=setpath($one_id);
            $where2.=" and path like '%{$path}%'";
        }
        if($admin_roleid==6){
            $path=setpath($adminid);
            $where2.=" and path like '%{$path}%'";
        }

        $uids=$Proxy->where($where2)->getField('uid',true);
        if(!$uids){
            $uids=[];
            array_push($uids,'0');
        }

        $where['id']  = array('in',$uids);
        
        /* 客户列表 */
		$count=M('users')->where($where)->count();
		$page = $this->page($count, 20);
		$users = M('users u')
            ->where($where)
            ->order("create_time DESC")
            ->limit($page->firstRow . ',' . $page->listRows)
            ->select();

        $Charge=M('users_charge');
        $Votes=M('users_voterecord');
        foreach($users as $k=>$v){

            $map=[];
            $map['uid']  = $v['id'];
            $total_charge=$Charge->where("status=1")->where($map)->sum('money');
            if(!$total_charge){
                $total_charge='0';
            }
            $v['total_charge']=$total_charge;
            
            $map2=[];
            $map2['uid']  = $v['id'];
            $total_votes=$Votes->where("type='income'")->where($map2)->sum('votes');
            if(!$total_votes){
                $total_votes='0';
            }
            $v['total_votes']=$total_votes;

            $users[$k]=$v;
            
        }
        
        /* 推广员列表 */
        $where_p=[];
        $where_p['u.user_type']='1';
        $where_p['r.role_id']='7';
        
        if($admin_roleid==6 ){
            $path=setpath($adminid);
            $uids=$Proxy->where("type = -1 and path like '%{$path}%'")->getField('uid',true);
            if(!$uids){
                $uids=[];
                array_push($uids,'0');
            }

            $where_p['u.id']  = array('in',$uids);
        }

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

	
	
}