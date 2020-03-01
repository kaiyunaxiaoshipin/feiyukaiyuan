<?php
/* 充值结算 */
namespace Admin\Controller;
use Common\Controller\AdminbaseController;
class SettlechargeController extends AdminbaseController{
    var $status=[
        '0'=>'未结算',
        '1'=>'已结算',
    ];
	function index(){

        $adminid=$_SESSION['ADMIN_ID'];
        $admin_roleid=$_SESSION['role_id'];
        $where=[];
        if($_REQUEST['keyword']!=''){
            $where['u.user_login|u.user_nicename']=array("like","%{$_REQUEST['keyword']}%");
            $_GET['keyword']=$_REQUEST['keyword'];
        }
        $Proxy=M('users_proxy');
        if($admin_roleid==6){
            /* 代理商查看 显示业务员 */
            $where['u.user_type']='1';
            $where['r.role_id']='7';
            $path=setpath($adminid);
            $uids=$Proxy->where("type=1 and path like '%{$path}%'")->getField('uid',true);
            if(!$uids){
                $uids=[];
                array_push($uids,'0');
            }
            $where['u.id']  = array('in',$uids);
        }else if($admin_roleid==7){
            /* 业务员查看 显示列表 */
            $where['u.id']  = $adminid;
        }else{
            /* 管理员查看  显示代理商 */
            $where['u.user_type']='1';
            $where['r.role_id']='6';
        }

        
        $Charge=M('users_charge');
        $Chargerecord=M('settlement_charge_record');

		$count=M('users u')->join('__ROLE_USER__ r ON r.user_id = u.id')->where($where)->count();
		$page = $this->page($count, 20);
		$lists = M('users u')
            ->join('__ROLE_USER__ r ON r.user_id = u.id')
            ->field('u.*')
            ->where($where)
            ->order("u.create_time DESC")
            ->limit($page->firstRow . ',' . $page->listRows)
            ->select();
            
        foreach($lists as $k=>$v){
            $v['isshow']='1';
            if($admin_roleid==7){
                $v['isshow']='0';
            }
            $where2=[];
            $path=setpath($v['id']);
            $where2['type']='0';
            $where2['path']=array('like',"%{$path}%");

            $uids=$Proxy->where($where2)->getField('uid',true);
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
            

            $total_chargeed=$Chargerecord->where("uid={$v['id']}")->sum('money');
            if(!$total_chargeed){
                $total_chargeed='0';
            }
            $v['total_chargeed']=$total_chargeed;
            
            $total_charge_no=$total_charge-$total_chargeed;
            $v['total_charge_no']=$total_charge_no;
            
            $lasttime='未结算';
            $lastrecord=$Chargerecord->where("uid={$v['id']}")->order('id desc')->find();
            if($lastrecord){
                $lasttime=date('Y-m-d H:i:s',$lastrecord['addtime']);
            }
            $v['lasttime']=$lasttime;

            
            $lists[$k]=$v;
            
        }        
		
        $this->assign('formget', $_GET);
		$this->assign("page", $page->show('Admin'));
		$this->assign("lists",$lists);
		$this->assign("admin_roleid",$admin_roleid);
		$this->assign("adminid",$adminid);
		$this->display();
	}
	
    /* 结算列表 */
    function index2(){
        $uid=(int)I('id');
        
        $userinfo=M('users')->field('user_login,user_nicename')->where("id={$uid}")->find();
        if($userinfo['user_nicename']==''){
            $userinfo['user_nicename']=$userinfo['user_login'];
        }
        
        $role_id=M('role_user')->where("user_id={$uid}")->getfield('role_id');
        if($role_id==6){
            $userinfo['role']='代理商';
        }else if($role_id==7){
            $userinfo['role']='业务员';
        }
        
        $this->assign('userinfo', $userinfo);
        
        $adminid=$_SESSION['ADMIN_ID'];
        $admin_roleid=$_SESSION['role_id'];
        
        $Proxy=M('users_proxy');
        $Charge=M('users_charge');
        $Chargesettle=M('settlement_charge');
        $Chargerecord=M('settlement_charge_record');

        $path=setpath($uid);
        $uids=$Proxy->where("type = 0 and path like '%{$path}%'")->getField('uid',true);
        if(!$uids){
            $uids=[];
            array_push($uids,'0');
        }

        $map=[];
        $map['uid']  = array('in',$uids);
        
        /* 生成结算列表 --start */
        $nowtime=time();
        //当天0点
        $today=date("Ymd",$nowtime);
        $today_start=strtotime($today);
        //当天 23:59:59
        $today_end=strtotime("{$today} + 1 day");

        $starttime=0;
        $ifexist=$Chargesettle->where("uid={$uid}")->order("id desc")->find();
        if($ifexist){
            $starttime=$ifexist['date']+60*60*24;
            
        }else{
            $first=$Charge->where("status=1")->where($map)->order("id asc")->find();
            if($first){
                $starttime=strtotime( date('Y-m-d',$first['addtime']) );
            }
        }

        if($starttime>0){
            $data_add=[];
            for($i=$starttime;$i<$today_start;){
                $end=$i+60*60*24;
                
                $total_charge=$Charge->where("status=1 and addtime>={$i} and addtime < {$end}")->where($map)->sum('money');
                if($total_charge){
                    $data_add_item=[
                        'uid'=>$uid,
                        'date'=>$i,
                        'money'=>$total_charge,
                    ];
                    $data_add[]=$data_add_item;
                }
                
                $i=$end;
            }
            if($data_add){
                $Chargesettle->addAll($data_add);
            }
            
        }
        /* 生成结算列表 --end */
        
        $where=[];
        $where3=[];
        $where['uid']=$uid;
        $_GET['id']=$uid;
        
        if($_REQUEST['start_time']!=''){
            $where['date']=array("egt",strtotime($_REQUEST['start_time']));
            $where3['addtime']=array("egt",strtotime($_REQUEST['start_time']));
            $_GET['start_time']=$_REQUEST['start_time'];
        }
         
        if($_REQUEST['end_time']!=''){
            $where['date']=array("elt",strtotime($_REQUEST['end_time']));
            $where3['addtime']=array("elt",strtotime($_REQUEST['end_time'])+60*60*24-1);
            $_GET['end_time']=$_REQUEST['end_time'];
        }
        if($_REQUEST['start_time']!='' && $_REQUEST['end_time']!='' ){
            $where['date']=array("between",array(strtotime($_REQUEST['start_time']),strtotime($_REQUEST['end_time'])));
            $where3['addtime']=array("between",array(strtotime($_REQUEST['start_time']),strtotime($_REQUEST['end_time'])+60*60*24-1));
            $_GET['start_time']=$_REQUEST['start_time'];
            $_GET['end_time']=$_REQUEST['end_time'];
        }
        
        $data=[];
        $total_charge=$Charge->where("status=1")->where($map)->where($where3)->sum('money');
        if(!$total_charge){
            $total_charge='0';
        }
        
        $data['total_charge']=$total_charge;
            

        $total_chargeed=$Chargesettle->where(" status='1'")->where($where)->sum('money');
        if(!$total_chargeed){
            $total_chargeed='0';
        }
        $data['total_chargeed']=$total_chargeed;
        
        $total_charge_no=$total_charge-$total_chargeed;
        $data['total_charge_no']=$total_charge_no;
        

		$count=$Chargesettle->where($where)->count();
		$page = $this->page($count, 20);
		$lists = $Chargesettle
            ->where($where)
            ->order("id DESC")
            ->limit($page->firstRow . ',' . $page->listRows)
            ->select();
            
		
        $this->assign('formget', $_GET);
		$this->assign("page", $page->show('Admin'));
		$this->assign("data",$data);
		$this->assign("lists",$lists);
		$this->assign("status",$this->status);
		$this->display();       
        
        
    }
    
    /* 结算 */
    function setSettle(){
        $uid=(int)I('id');
        $where=[];
        $where3=[];
        $where['uid']=$uid;
        
        $nowtime=time();
        //当天0点
        $today=date("Ymd",$nowtime);
        $today_start=strtotime($today);

        
        $time_slot='全部';
        $_GET['id']=$uid;
        if($_REQUEST['start_time']!=''){
            $where['date']=array("egt",strtotime($_REQUEST['start_time']));
            $_GET['start_time']=$_REQUEST['start_time'];
            
            $time_slot=$_REQUEST['start_time'].'之后';
        }
         
        if($_REQUEST['end_time']!=''){
            $where['date']=array("elt",strtotime($_REQUEST['end_time']));
            $_GET['end_time']=$_REQUEST['end_time'];
            $time_slot=$_REQUEST['end_time'].'之前';
        }
        if($_REQUEST['start_time']!='' && $_REQUEST['end_time']!='' ){
            $where['date']=array("between",array(strtotime($_REQUEST['start_time']),strtotime($_REQUEST['end_time'])));
            $_GET['start_time']=$_REQUEST['start_time'];
            $_GET['end_time']=$_REQUEST['end_time'];
            
            $time_slot=$_REQUEST['start_time'].'--'.$_REQUEST['end_time'];
        }
        
        
        $Chargesettle=M('settlement_charge');
        $Chargerecord=M('settlement_charge_record');
        
        $total=$Chargesettle->where("status=0")->where($where)->sum('money');
        if(!$total){
            $this->error('当前时间段内无有效结算',U('Settlecharge/index2',array('id'=>$uid,'start_time'=>$_GET['start_time'],'end_time'=>$_GET['end_time'])));
        }
        
        $Chargesettle->where("status=0")->where($where)->save(['status'=>1,'uptime'=>time()]);
        $record=[
            'uid'=>$uid,
            'date'=>time(),
            'money'=>$total,
            'addtime'=>time(),
            'time_slot'=>$time_slot,
        ];
        $Chargerecord->add($record);
        
        
        $this->success('结算成功',U('Settlecharge/index2',array('id'=>$uid,'start_time'=>$_GET['start_time'],'end_time'=>$_GET['end_time'])));
    }

    /* 结算记录 */
    function record(){
        $uid=(int)I('id');
        
        $where=[];
        $where['uid']=$uid;
        $Chargerecord=M('settlement_charge_record');
        
        $userinfo=M('users')->field('user_login,user_nicename')->where("id={$uid}")->find();
        if($userinfo['user_nicename']==''){
            $userinfo['user_nicename']=$userinfo['user_login'];
        }
        
        $role_id=M('role_user')->where("user_id={$uid}")->getfield('role_id');
        if($role_id==6){
            $userinfo['role']='代理商';
        }else if($role_id==7){
            $userinfo['role']='业务员';
        }
        
		$count=$Chargerecord->where($where)->count();
		$page = $this->page($count, 20);
		$lists = $Chargerecord
            ->where($where)
            ->order("id DESC")
            ->limit($page->firstRow . ',' . $page->listRows)
            ->select();

		
        $this->assign('formget', $_GET);
		$this->assign("page", $page->show('Admin'));
		$this->assign("lists",$lists);
		$this->assign("userinfo",$userinfo);
		$this->display();        
    }
	
	
}