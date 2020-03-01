<?php
/**
 * 充值示范页面
 * Created by codepay.
 * Date: 2017/8/2
 * Time: 15:03
 */

//$myhost = 'localhost:3306';      // mysql服务器主机地址
//$myusername = 'yunbao6';            // mysql用户名
//$mypassword = 'CCpBZeyTAayKe4bk';            // mysql用户名密码
//$conn = mysqli_connect($myhost , $myusername , $mypassword );
//if(! $connect )
//{
//    die('连接失败: ' . mysqli_error($connect ));
//}
//
//mysqli_query($connect , "set names utf8");// 设置编码，防止中文乱码
//
//$sql = mysql_query("select * from table_name");//将表table_name的全部数据存放到$sql
//
//$row = mysql_fetch_row($sql);//获取$sql里面的第一个数据作为数组存储在$row中*/*/
//     $sql = mysql_query("select coin from cmf_user where id=1"); //执行模糊查询
//
//    $row = mysql_fetch_row($sql);  //逐行获取查询结果，返回值为数组


error_reporting(E_ALL & ~E_NOTICE);
session_start(); //开启session

require_once("codepay_config.php"); //导入配置文件
//echo session_id();
//print_r($_SESSION['uid']);
//print_r($_SESSION);// 打印全部SESSION  需要先开启session
//print_r($_COOKIE);// 打印全部cookie
//$coin=M('user')->where(['id'=>$uid])->value('coin');
//print_r($coin);

//trim($_GET['id'])
$username = $_SESSION['uid']; //
$user = $username ? $username : $_SESSION['uid'];  //传入默认用户 默认为admin


//$Mycoin = $_SESSION['coin'];


//$user =strip_tags($user); //将HTML标签去掉 可以防止XSS跨站


//$user可以从$_SESSION或者$_COOKIE里取出当前登录的用户。 不同网站未必都有保存 也许保存的用户ID

//比如session中数组名为username取到了当前登录的用户名  则为 $user = $_SESSION['username'];


//$_SESSION["uuid"]=guid();//生成UUID 添加到网页表单 防止使用部分软件恶意提交订单
//$salt=md5($_SESSION["uuid"]); //这是用于表单防跨站提交

if ((int)$codepay_config['id'] <= 1) { //未修改配置文件
    exit('1<!--
<h3>您需要修改配置文件：codepay_config.php 或者安装码支付接口 才能显示该页面。 <a href="install.php">点击安装</a></h3>-->
');
} ?>
<!DOCTYPE html>
<html>
<head><title>
        在线充值
    </title>
    <meta http-equiv="Content-Type" content="text/html; charset=<?php echo $codepay_config['chart'] ?>">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, user-scalable=no, maximum-scale=1.0"/>
    <meta content="yes" name="apple-mobile-web-app-capable"/>
    <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
    <meta content="telephone=no" name="format-detection"/>
    <link rel="stylesheet" type="text/css" href="css/userPay.css">

    <style>
        a:link {
            text-decoration: none;
        }

        　　 a:active {
            text-decoration: blink
        }

        　　 a:hover {
            text-decoration: underline;
        }

        　　 a:visited {
            text-decoration: none;
        }

        *, :after, :before {
            /* -webkit-box-sizing: border-box; */
            -moz-box-sizing: border-box;
            box-sizing: border-box;
        }

        button, html input[type=button], input[type=reset], input[type=submit] {
            -webkit-appearance: button;
            cursor: pointer;
        }
    </style>
    <!--[if lt IE 9]>
    <script src="js/html5shiv.min.js"></script>
    <script src="js/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<div id="loadingPicBlock" style="max-width: 720px;margin:0 auto;" class="pay">
<!--    <header class="g-header">-->
<!---->
<!--        <div class="head-r">-->
<!--            <a href="/" class="z-HReturn" data-dismiss="modal" aria-hidden="true"><s></s><b>首页</b></a>-->
<!--        </div>-->
<!--    </header>-->

    <div class="g-Total gray9">请选择您需要充值的金额</div>
    <section class="clearfix g-member">
        <div class="g-Recharge">
            <ul id="ulOption">
                <!--注意修改金额 需要同时修改前面的值 money="10" -->
                <li money="10"><a href="javascript:;">100鱼币<s></s></a></li>
                <li money="20"><a href="javascript:;">200鱼币<s></s></a></li>
                <li money="50"><a href="javascript:;" class="z-sel">50元<s></s></a></li> <!--class="z-sel" 表示默认选中50元-->
                <li money="55"><a href="javascript:;">550鱼币<s></s></a></li>
                <li money="100"><a href="javascript:;">1000鱼币<s></s></a></li>
                <li money="108"><a href="javascript:;">1080鱼币<s></s></a></li>
                <li money="200"><a href="javascript:;">2000鱼币<s></s></a></li>
                <li money="218"><a href="javascript:;">2180鱼币<s></s></a></li>
                <li money="500"><a href="javascript:;">5000鱼币<s></s></a></li>
                <li money="530"><a href="javascript:;">5300鱼币<s></s></a></li>
                <li money="1000"><a href="javascript:;">10000鱼币<s></s></a></li>
                <li money="1050"><a href="javascript:;">10500鱼币<s></s></a></li>
                <li money="2000"><a href="javascript:;">20000鱼币<s></s></a></li>
                <li money="2100"><a href="javascript:;">21000鱼币<s></s></a></li>
                <li money="3000"><a href="javascript:;">30000鱼币<s></s></a></li>
                <li money="5000"><a href="javascript:;">50000鱼币<s></s></a></li>
                <li money="5100"><a href="javascript:;">51000鱼币<s></s></a></li>
            </ul>
        </div>
<!--        readonly="readonly"-->
        <form action="ScanPay.php" method="post">
            <article class="clearfix mt10 m-round g-pay-ment g-bank-ct">
                <ul id="ulBankList">
                    <li class="gray6" style="width: 100%;padding: 5px 0px 0px 10px;height: 50px;">应付金额：<label
                            class="input" style="border: 1px solid #EAEAEA;height: 35px;font-size:30px;">
                            <input type="text"   name="price" id="price" placeholder="如：50" value="50"
                                   style="width: 170px;color: red;font-size:20px;">   <!--默认输入金额值50-->
                        </label> 元
                    </li>
                    <li class="gray6"
                        style="width: 100%;padding: 5px 0px 0px 10px;display: <?php echo $codepay_config['userOff'] && $user ? 'none' : 'inline'; ?>;height: 50px;">
                        用户ID：<label
                            class="input" style="border: 1px solid #EAEAEA;height: 30px;font-size: 30px;">
                            <input type="text" name="user" id="user" placeholder="{$uid}" value="<?php echo $user ?>"
                                   style="width: 180px;font-size: 16px;">
                        </label></li>
                    <li paytype="1" class="gray9" type="codePay" style="width: 33%">
                        <a href="javascript:;" class="z-initsel"><img src="img/alipay.jpg"><s></s></a>

                    </li>
                    <li paytype="3" class="gray9" type="codePay" style="width: 33%">
                        <a href="javascript:;"><img src="img/weixin.jpg"><s></s></a>

                    </li>
                    <li paytype="2" class="gray9" type="codePay" style="width: 33%">
                        <a href="javascript:;"><img src="img/qqpay.jpg"><s></s></a>
                    </li>
                </ul>
            </article>
            <input type="hidden" id="pay_type" value="1" name="type"> <!--值1表示支付宝默认-->
            <input type="hidden" value="<?php echo $salt; ?>" name="salt">

            <div class="mt10 f-Recharge-btn">

                <button id="btnSubmit" type="submit" href="javascript:;" class="orgBtn">确认支付</button>
            </div>
        </form>
    </section>

    <input id="hidIsHttps" type="hidden" value="0"/>
    <script src="js/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

        $(function () {
            var c;
            var g = false;
            var a = null;
            var e = function () {
                $("#ulOption > li").each(function () {
                    var n = $(this);
                    n.click(function () {
                        g = false;
                        c = n.attr("money");
                        n.children("a").addClass("z-sel");
                        n.siblings().children().removeClass("z-sel").removeClass("z-initsel");
                        var needMoney = parseFloat(n.attr("money")).toFixed(2);
                        if (needMoney <= 0)needMoney = 0.01;
                        $("#price").val(needMoney);
                    })
                });
                $("#ulBankList > li").each(function (m) {
                    var n = $(this);
                    n.click(function () {
                        if (m < 2)return;
                        $("#pay_type").val(n.attr("payType"));
                        n.children("a").addClass("z-initsel");
                        n.siblings().children().removeClass("z-initsel");
                    })
                });

            };
            e()
        });

    </script>


</div>
</body>
</html>