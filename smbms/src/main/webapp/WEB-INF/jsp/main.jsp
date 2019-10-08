<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>超市管理系统-后台首页</title>
    <!--引入easyui的css-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/easyui/themes/default/easyui.css">
    <!--引入icon小图标的样式-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/easyui/themes/icon.css">
    <!--引入相关的js文件，必须先引入jQuery-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/easyui/jquery.min.js"></script>
    <!--easyui的js文件-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/easyui/jquery.easyui.min.js"></script>
    <!--汉化，导入汉化插件-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/easyui/easyui-lang-zh_CN.js"></script>
    <style type="text/css">

        .clock {
            float:right;
            width: 300px;
            height: 30px;
            padding-left: 20px;
            color: rgb(0, 76, 126);
            background: url(${pageContext.request.contextPath }/static/images/clock.gif) no-repeat;
            font-size: 14px;
        }

        .userInfo{
            float:left;
            padding-left: 20px;
            padding-top: 30px;
        }
    </style>
    <script type="text/javascript">
        //显示时间
        function showTime(){
            var date = new Date();
            this.year = date.getFullYear();
            this.month = date.getMonth() + 1;
            this.date = date.getDate();
            this.day = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六")[date.getDay()];
            this.hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
            this.minute = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
            this.second = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
            $("#clock").text("现在是:" + this.year + "年" + this.month + "月" + this.date + "日 " + this.hour + ":" + this.minute + ":" + this.second + " " + this.day);
        }

        /**
         * 打开新的tabs选项卡
         * @param text  选项卡显示的文本
         * @param url   对应选项卡页面的路径
         * @param iconCls   选项卡的icon图标
         */
        function openTab(text,url,iconCls){
            //判断选项卡是否存在
            if($("#tabs").tabs("exists",text)){
                //选中存在的文本
                $("#tabs").tabs("select",text);
            //没有选中则添加一个新的选项卡
            }else{
                var content="<iframe frameborder=0 scrolling='auto' style='width:100%;height:100%' src='${pageContext.request.contextPath}/"+url+"'></iframe>";
                $("#tabs").tabs("add",{
                    title:text,
                    iconCls:iconCls,
                    closable:true,
                    content:content
                });
            }
        }

        $(function () {
            showTime();
            //实时刷新时间
            setInterval("showTime()",1000);

            //给tabs选项卡绑定右键菜单
            // 监听右键事件，创建右键菜单
            $('#tabs').tabs({
                onContextMenu:function(e, title,index){
                    e.preventDefault();
                    if(index>0){
                        $('#menu').menu('show', {
                            left: e.pageX,
                            top: e.pageY
                        }).data("tabTitle", title);
                    }
                }
            });

            // 右键菜单click
            $("#menu").menu({
                onClick : function (item) {
                    //调用关闭选项卡事件
                    closeTab(this, item.name);
                }
            });

            /**
             * 关闭选项卡
             * @param menu
             * @param type
             * @returns {boolean}
             */
            function closeTab(menu, type) {
                var allTabs = $("#tabs").tabs('tabs');//获取所有的选项卡面板
                var allTabtitle = [];
                //循环所有打开的tabs选项卡，并将打开的选项卡添加到数组中
                $.each(allTabs, function (i, n) {
                    var opt = $(n).panel('options');
                    if (opt.closable)
                        allTabtitle.push(opt.title);
                });
                var curTabTitle = $(menu).data("tabTitle");
                //当前选项卡的索引位置
                var curTabIndex = $("#tabs").tabs("getTabIndex", $("#tabs").tabs("getTab", curTabTitle));
                switch (type) {
                    case 2: // 关闭当前标签页
                        $("#tabs").tabs("close", curTabIndex);
                        return false;
                        break;
                    case 3: // 关闭全部标签页
                        for (var i = 0; i < allTabtitle.length; i++) {
                            $('#tabs').tabs('close', allTabtitle[i]);
                        }
                        break;
                    case 4: // 关闭其他标签页
                        for (var i = 0; i < allTabtitle.length; i++) {
                            if (curTabTitle != allTabtitle[i])
                                $('#tabs').tabs('close', allTabtitle[i]);
                        }
                        $('#tabs').tabs('select', curTabTitle);
                        break;
                    case 5: // 关闭右侧标签页
                        for (var i = curTabIndex; i < allTabtitle.length; i++) {
                            $('#tabs').tabs('close', allTabtitle[i]);
                        }
                        $('#tabs').tabs('select', curTabTitle);
                        break;
                    case 6: // 关闭左侧标签页
                        for (var i = 0; i < curTabIndex - 1; i++) {
                            $('#tabs').tabs('close', allTabtitle[i]);
                        }
                        $('#tabs').tabs('select', curTabTitle);
                        break;

                }

            }
        })

    </script>
</head>

<body class="easyui-layout">
    <%--头部--%>
    <div data-options="region:'north'" style="height:72px;">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="381px" style="background:url(${pageContext.request.contextPath }/static/images/top_center.jpg)">
                    <img src="${pageContext.request.contextPath }/static/images/logo.png" width="320px">
                </td>
                <td style="background:url(${pageContext.request.contextPath }/static/images/top_center.jpg)">
                    <div id="userInfo" class="userInfo">欢迎${loginUser.userName }</div>
                </td>
                <td valign="bottom" width="544px" style="background:url(${pageContext.request.contextPath }/static/images/top_right.jpg)">
                    <div id="clock" class="clock"></div>
                </td>
            </tr>
        </table>
    </div>
    <!--左边部分-->
    <div region="west" style="width: 200px" title="导航菜单" split="true" iconCls="icon-navigation">
        <!--分类效果-->
        <div class="easyui-accordion" data-options="fit:true,border:false">
            <!--第一个菜单项-->
            <div title="基本资料管理" data-options="selected:true,iconCls:'icon-zlgl'" style="padding: 10px">
                <a href="javascript:openTab('用户管理','user/touserlist','icon-user')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-user'" style="width: 150px">用户管理</a>
                <a href="javascript:openTab('账单管理','bill/tobilllist','icon-zdgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-zdgl'" style="width: 150px">账单管理</a>
                <a href="javascript:openTab('供应商管理','provider/toprovider','icon-gysgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-gysgl'" style="width: 150px">供应商管理</a>
            </div>
            <!--第二个菜单项-->
            <div title="系统管理"  data-options="iconCls:'icon-item'" style="padding:10px">
                <a href="javascript:openPasswordModifyDialog()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-modifyPassword'" style="width: 150px;">修改密码</a>
                <a href="javascript:logout()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-exit'" style="width: 150px;">安全退出</a>
            </div>
        </div>
    </div>
    <!--中间部分-->
    <div data-options="region:'center'" style="padding:5px;background:#eee;">
        <div class="easyui-tabs" fit="true" border="false" id="tabs">
            <div title="首页" data-options="iconCls:'icon-home'">
                <div align="center" style="padding-top: 100px"><font color="red" size="10">欢迎使用</font></div>
            </div>
        </div>
    </div>
    <!--底部-->
    <div region="south" style="height: 30px;padding: 5px" align="center">
        Copyright © 2016-2019 北大青鸟  版权所有
    </div>

    <!--添加右键菜单-->
    <div id="menu" class="easyui-menu">
        <div id="mm-tabclose" data-options="name:2,iconCls:'icon-closetab'">关闭当前标签页</div>
        <div id="mm-tabcloseall" data-options="name:3,iconCls:'icon-closealltab'">关闭全部标签页</div>
        <div id="mm-tabcloseother" data-options="name:4,iconCls:'icon-closeothertab'">关闭其他标签页</div>
        <div id="mm-tabcloseright" data-options="name:5,iconCls:'icon-closerighttab'">关闭右侧标签页</div>
        <div id="mm-tabcloseleft" data-options="name:6,iconCls:'icon-closelefttab'">关闭左侧标签页</div>
    </div>


</body>

</html>