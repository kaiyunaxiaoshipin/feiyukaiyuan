<?php

class Api_Livepk extends PhalApi_Api {

	public function getRules() {
		return array(
			'getLiveList' => array(
                'uid' => array('name' => 'uid', 'type' => 'int', 'min' => 1, 'require' => true, 'desc' => '用户ID'),
				'p' => array('name' => 'p', 'type' => 'int', 'default' => 1, 'desc' => '页码'),
			),
			'search' => array( 
				'uid' => array('name' => 'uid', 'type' => 'int', 'min' => 1, 'require' => true, 'desc' => '用户ID'),
				'key' => array('name' => 'key', 'type' => 'string', 'require' => true, 'desc' => '关键词'),
				'p' => array('name' => 'p', 'type' => 'int', 'default' => 1, 'desc' => '页码'),
			),
			'checkLive' => array(
				'stream' => array('name' => 'stream', 'type' => 'string', 'require' => true, 'desc' => '连麦主播流名'),
                'uid_stream' => array('name' => 'uid_stream', 'type' => 'string', 'require' => true, 'desc' => '当前主播流名'),
			),
            
            'changeLive' => array(
                'uid' => array('name' => 'uid', 'type' => 'int', 'min' => 1, 'require' => true, 'desc' => '用户ID'),
				'pkuid' => array('name' => 'pkuid', 'type' => 'int', 'require' => true, 'desc' => '连麦主播ID'),
				'type' => array('name' => 'type', 'type' => 'int', 'require' => true, 'desc' => '标识'),
				'sign' => array('name' => 'sign', 'type' => 'string', 'require' => true, 'desc' => '签名'),
			),
		);
	}

	/**
	 * 直播用户
	 * @desc 用于 获取直播中的用户
	 * @return int code 操作码，0表示成功
	 * @return array info 
	 * @return string info[].uid 主播ID
	 * @return string info[].pkuid PK对象ID，0表示未连麦
	 * @return string msg 提示信息
	 */
	public function getLiveList() {
		$rs = array('code' => 0, 'msg' => '', 'info' => array());
        
        $uid=checkNull($this->uid);
        $p=checkNull($this->p);
        if(!$p){
            $p=1;
        }
        
        $where="uid!={$uid}";

		$domain = new Domain_Livepk();
		$list = $domain->getLiveList($uid,$where,$p);
        
        foreach($list as $k=>$v){
            $userinfo=getUserInfo($v['uid']);
            $v['level']=$userinfo['level'];
            $v['level_anchor']=$userinfo['level_anchor'];
            $v['sex']=$userinfo['sex'];
            $list[$k]=$v;
        }

		$rs['info']=$list;
		return $rs;			
	}
    
	/**
	 * 搜索直播用户
	 * @desc 用于搜索直播中用户
	 * @return int code 操作码，0表示成功
	 * @return array info 
	 * @return string info[].uid 主播ID
	 * @return string info[].pkuid PK对象ID，0表示未连麦
	 * @return string msg 提示信息
	 */
	public function search() {
		$rs = array('code' => 0, 'msg' => '', 'info' => array());
        
        $uid=checkNull($this->uid);
        $key=checkNull($this->key);
        $p=checkNull($this->p);
        if(!$p){
            $p=1;
        }
        
        if($key==''){
            $rs['code']=1001;
            $rs['msg']='请输入您要搜索的主播昵称或ID';
            return $rs;
        }
        
        $list=DI()->notorm->users
                ->select('id')
                ->where("id!={$uid} and (id='{$key}' or user_nicename like '%{$key}%')")
                ->fetchAll();
        if(!$list){
            return $rs;
        }

        $uids=array_column($list,'id');
        
        $uids_s=implode(',',$uids);
        
        $where="uid!={$uid} and uid in ({$uids_s})";
        
		$domain = new Domain_Livepk();
		$list = $domain->getLiveList($uid,$where,$p);
        
        foreach($list as $k=>$v){
            $userinfo=getUserInfo($v['uid']);
            $v['level']=$userinfo['level'];
            $v['level_anchor']=$userinfo['level_anchor'];
            $v['sex']=$userinfo['sex'];
            $list[$k]=$v;
        }

		$rs['info']=$list;
		return $rs;			
	}

	/**
	 * 检测是否直播中
	 * @desc 用于检测要连麦主播是否直播中
	 * @return int code 操作码，0表示成功
	 * @return array info 
	 * @return string msg 提示信息
	 */
	public function checkLive() {
		$rs = array('code' => 0, 'msg' => '', 'info' => array());
        
        $stream=checkNull($this->stream);
        $uid_stream=checkNull($this->uid_stream);
        
		$domain = new Domain_Livepk();
		$info = $domain->checkLive($stream);

        if(!$info){
            $rs['code']=1001;
            $rs['msg']='对方已关播';
            return $rs;
        }

		$configpri = getConfigPri(); 
        $nowtime=time();

        $live_sdk=$configpri['live_sdk'];  //live_sdk  0表示金山SDK 1表示腾讯SDK
        if($live_sdk==1){
            $bizid = $configpri['tx_bizid'];
            $push_url_key = $configpri['tx_push_key'];
            $push = $configpri['tx_push'];
            $pull = $configpri['tx_pull'];

            $now_time2 = $nowtime + 3*60*60;
            $txTime = dechex($now_time2);
            
            $live_code = $uid_stream ;

            $txSecret = md5($push_url_key . $live_code . $txTime);
            
            $safe_url = "&txSecret=" . $txSecret."&txTime=" .$txTime;
            $play_url = "rtmp://" . $pull . "/live/" .$live_code. "?bizid=" . $bizid .$safe_url;
            
        }else if($configpri['cdn_switch']==5){
			$liveinfo=DI()->notorm->users_live
                ->select('pull')
                ->where('stream=?',$uid_stream)
                ->fetchOne();
                
			$play_url=$liveinfo['pull'];
		}else{
			$play_url=PrivateKeyA('rtmp',$uid_stream,0);
		}
		
        $info=array(
			"pull" => $play_url
		);

		$rs['info'][0]=$info;
        
		return $rs;			
	}


	/**
	 * 修改直播信息
	 * @desc 用于连麦成功后更新数据库信息
	 * @return int code 操作码，0表示成功
	 * @return array info 
	 * @return string msg 提示信息
	 */
	public function changeLive() {
		$rs = array('code' => 0, 'msg' => '', 'info' => array());
        
        $uid = $this->uid;
		$pkuid=checkNull($this->pkuid);

		$type=checkNull($this->type);
		$sign=checkNull($this->sign);
        
        $checkdata=array(
            'uid'=>$uid,
            'pkuid'=>$pkuid,
            'type'=>$type,
        );
        
        $issign=checkSign($checkdata,$sign);

        if(!$issign){
            $rs['code']=1001;
			$rs['msg']='签名错误';
			return $rs;	
        } 

		$domain = new Domain_Livepk();
		$info = $domain->changeLive($uid,$pkuid,$type);


		return $rs;			
	}

}
