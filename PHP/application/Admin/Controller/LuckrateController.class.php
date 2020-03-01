<?php

/**
 * 幸运礼物中奖设置
 */
namespace Admin\Controller;
use Common\Controller\AdminbaseController;
class LuckrateController extends AdminbaseController {
    var $numslist=['1','10','66','88','100','520','1314'];
    function index(){
        $giftid=I('giftid');
        $map['giftid']=$giftid;
        
        $giftinfo=M('gift')
            ->field('giftname')
            ->where("id={$giftid}")
            ->find();
        
    	$jackpot=M("luck_rate");
    	$count=$jackpot->where($map)->count();
    	$page = $this->page($count, 20);
    	$lists = $jackpot
            ->where($map)
            ->order("id desc")
            ->limit($page->firstRow . ',' . $page->listRows)
            ->select();

    	$this->assign('lists', $lists);
    	$this->assign('giftid', $giftid);
    	$this->assign('giftinfo', $giftinfo);

    	$this->assign("page", $page->show('Admin'));
    	
    	$this->display();
    }
   
		
    function del(){
        $id=intval($_GET['id']);
        if($id){
            $result=M("luck_rate")->delete($id);				
                if($result){
                    $this->resetcache();
                    $this->success('删除成功');
                 }else{
                    $this->error('删除失败');
                 }			
        }else{				
            $this->error('数据传入失败！');
        }								  
        $this->display();				
    }

    function add(){
        $giftid=I('giftid');
        $this->assign('giftid', $giftid);
        $this->assign('numslist', $this->numslist);
        $this->display();				
    }
    
    function add_post(){
        if(IS_POST){
            $jackpot=M("luck_rate");
            $jackpot->create();
            
            $giftid=I('giftid');
            $nums=I('nums');
            $times=I('times');

            
            if($times < 0){
				$this->error('中奖倍数不能小于0');
			}
            
            $check = $jackpot->where("giftid='{$giftid}' and nums='{$nums}' and times = '{$times}'")->find();
            if($check){
                $this->error('相同数量、倍数的配置已存在');
            }

             $jackpot->addtime=time();
             $result=$jackpot->add(); 
             if($result){
                 $this->resetcache();
                $this->success('添加成功');
             }else{
                $this->error('添加失败');
             }
        }			
    }		
    function edit(){
        $id=intval($_GET['id']);
        if($id){
            $data=M("luck_rate")->find($id);
            
            
            $this->assign('numslist', $this->numslist);
            $this->assign('data', $data);						
        }else{				
            $this->error('数据传入失败！');
        }								  
        $this->display();				
    }
    
    function edit_post(){
        if(IS_POST){			
             $jackpot=M("luck_rate");
             $jackpot->create();
             
            $id=I('id');
            $giftid=I('giftid');
            $nums=I('nums');
            $times=I('times');

            if($times < 0){
				$this->error('中奖倍数不能小于0');
			}
            
            $check = $jackpot->where("giftid='{$giftid}' and nums='{$nums}' and times = '{$times}' and id!={$id}")->find();
            if($check){
                $this->error('相同数量、倍数的配置已存在');
            }

             $result=$jackpot->save(); 
             if($result!==false){
                 $this->resetcache();
                  $this->success('修改成功');
             }else{
                  $this->error('修改失败');
             }
        }			
    }
     function resetcache(){
		$key='luck_rate';

        $level= M("luck_rate")->order("id desc")->select();
        if($level){
            setcaches($key,$level);
        }
       
        return 1;
    }       

}
