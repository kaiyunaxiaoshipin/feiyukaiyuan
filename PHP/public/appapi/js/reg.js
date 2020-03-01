$(function(){

    var isiPad = /iPad/i.test(navigator.userAgent);
    var isiPhone = /iPhone|iPod/i.test(navigator.userAgent);
    var isAndroid = /Android/i.test(navigator.userAgent);
    var isWeixin = /MicroMessenger/i.test(navigator.userAgent);
    var isQQ = /QQ/i.test(navigator.userAgent);
    var isIOS = (isiPad || isiPhone);
    var isWeibo = /Weibo/i.test(navigator.userAgent);
    var isApp = (isAndroid || isIOS);
    
    if(isWeixin){
        $('.reg_bottom_wx').show();
    }

	var isbuy=0;
    var js_getCode=$("#getCode");

	js_getCode.on("click",function(){
		if(isbuy){
			return !1;
		}
        var userlogin=js_userlogin.val();
		if(userlogin==''){
			layer.msg("请输入您的手机号");
			return !1;
		}
        
        if(js_getCode.hasClass('login_counting')){
            return !1;
        }

		isbuy=1;
		$.ajax({
			url:'/index.php?g=appapi&m=reg&a=getCode',
			data:{mobile:userlogin},
			type:'POST',
			dataType:'json',
			success:function(data){
				isbuy=0;
				if(data.code==0){
					layer.msg(data.msg,{},function(){
						js_getCode.addClass('login_counting');
                        login_counting();
					});
					
					return !1;
				}else{
					layer.msg(data.msg);
					return !1;
				}
			},
			error:function(){
				isbuy=0;
				layer.msg("请求失败");
				return !1;
			}
			
		})
	})
    var interval_reg;
    function login_counting(){
        var e = 60;
        interval_reg = window.setInterval(function() {
            if (e > 0) {
                var i = e--+"s 重新获取";
                js_getCode.addClass("login_counting");
                js_getCode.val(i);
            } else{
                window.clearInterval(interval_reg);
                interval_reg = null;
                js_getCode.val('获取验证码');
                js_getCode.removeClass("login_counting");
            } 
        }, 1e3)			
    }
    
    var js_userlogin=$("#userlogin");
    var js_usercode=$("#usercode");
    var js_userpass=$("#userpass");
    var js_userpass2=$("#userpass2");
    var js_reg_login=$(".reg_bottom_login");
    var js_reg_wx=$(".reg_bottom_wx");
    
	js_reg_login.on("click",function(){
        var userlogin=js_userlogin.val(); 
        var usercode=js_usercode.val(); 
        var userpass=js_userpass.val(); 
        var userpass2=js_userpass2.val();
        
		isbuy=1;
		$.ajax({
			url:'/index.php?g=appapi&m=reg&a=register',
			data:{userlogin:userlogin,usercode:usercode,userpass:userpass,userpass2:userpass2,agentid:agentid},
			type:'POST',
			dataType:'json',
			success:function(data){
				isbuy=0;
				if(data.code==0){
					layer.msg(data.msg,{},function(){
                        location.href="/index.php?g=appapi&m=down&a=index"
					});
					return !1;
				}else{
					layer.msg(data.msg);
					return !1;
				}
			},
			error:function(){
				isbuy=0;
				layer.msg("请求失败");
				return !1;
			}
			
		})
    })
    js_reg_wx.on("click",function(){
        location.href="/index.php?g=appapi&m=reg&a=wxLogin&agentid="+agentid;
    })
})