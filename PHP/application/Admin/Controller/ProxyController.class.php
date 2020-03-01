<?php
/* 代理管理 */
namespace Admin\Controller;
use Common\Controller\AdminbaseController;
class ProxyController extends AdminbaseController{
	protected $users_model,$role_model;
	
	function _initialize() {
		parent::_initialize();
		$this->users_model = D("Common/Users");
		$this->role_model = D("Common/Role");
	}
	function index(){

        $where=[];
        $where['u.user_type']='1';
        $where['r.role_id']='6';
        
        
        if($_REQUEST['keyword']!=''){
            $where['u.user_login|u.user_nicename']=array("like","%{$_REQUEST['keyword']}%");
            $_GET['keyword']=$_REQUEST['keyword'];
        }
        
		$count=M('users u')->join('__ROLE_USER__ r ON r.user_id = u.id')->where($where)->count();
		$page = $this->page($count, 20);
		$users = M('users u')
            ->join('__ROLE_USER__ r ON r.user_id = u.id')
            ->field('u.*')
            ->where($where)
            ->order("u.create_time DESC")
            ->limit($page->firstRow . ',' . $page->listRows)
            ->select();
        $Proxy=M('users_proxy');
        $Charge=M('users_charge');
        $Votes=M('users_voterecord');
        $User=M('users');
        foreach($users as $k=>$v){
            $path=setpath($v['id']);
            $uids=$Proxy->where("type=0 and path like '%{$path}%'")->getField('uid',true);
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
		
        $this->assign('formget', $_GET);
		$this->assign("page", $page->show('Admin'));
		$this->assign("users",$users);
		$this->display();
	}
	
	
	function add(){

		$this->display();
	}
	
	function add_post(){
		if(IS_POST){
			if(!empty($_POST['role_id']) && is_array($_POST['role_id'])){
				$role_ids=$_POST['role_id'];
				unset($_POST['role_id']);
				if ($this->users_model->create()) {
					$result=$this->users_model->add();
					if ($result!==false) {
						$role_user_model=M("RoleUser");
						foreach ($role_ids as $role_id){
							$role_user_model->add(array("role_id"=>$role_id,"user_id"=>$result));
						}
                        
                        $action="添加代理商：{$result}";
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
				if ($this->users_model->create()) {
					$result=$this->users_model->save();
					if ($result!==false) {
						$uid=intval($_POST['id']);
						$role_user_model=M("RoleUser");
						$role_user_model->where(array("user_id"=>$uid))->delete();
						foreach ($role_ids as $role_id){
							$role_user_model->add(array("role_id"=>$role_id,"user_id"=>$uid));
						}
                        
                        $action="编辑代理商：{$uid}";
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
			$this->error("最高代理商不能删除！");
		}
		
		if ($this->users_model->where("id=$id")->delete()!==false) {
			M("RoleUser")->where(array("user_id"=>$id))->delete();
            $action="删除代理商：{$id}";
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
                $action="停用代理商：{$id}";
                    setAdminLog($action);
    			$this->success("代理商停用成功！");
    		} else {
    			$this->error('代理商停用失败！');
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
                $action="启用代理商：{$id}";
                    setAdminLog($action);
    			$this->success("代理商启用成功！");
    		} else {
    			$this->error('代理商启用失败！');
    		}
    	} else {
    		$this->error('数据传入失败！');
    	}
    }
	
	
	
}