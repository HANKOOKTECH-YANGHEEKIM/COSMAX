<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	String login_id = loginUser.getLoginId();

	//-- 검색값 셋팅
	BeanResultMap searchMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= searchMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= searchMap.getString(CommonConstants.PAGE_ROWSIZE);
	String callbackFunction		= searchMap.getString("CALLBACKFUNCTION");
	
	String schMenu				= searchMap.getString("SCHMENU");
	String schSmenu			= searchMap.getString("SCHSMENU");
	String schType				= searchMap.getString("SCHTYPE");
	String schClass				= searchMap.getString("SCHCLASS");
	String schNat				= searchMap.getString("SCHNAT");
	String schStatus			= searchMap.getString("SCHSTATUS");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 		= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode 			= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);
	
	SQLResults CMM_USER_AUTH	= resultMap.getResult("CMM_USER_AUTH");
	
	int cnt = 0;
%>  
<link rel="stylesheet" href="/common/_lib/jqwidgets/jqwidgets/styles/jqx.base.css" type="text/css" />
<link rel="stylesheet" href="/common/_lib/jqwidgets/jqwidgets/styles/jqx.custom_for_menu.css" type="text/css" />
<script type="text/javascript" src="/common/_lib/jqwidgets/jqwidgets/jqxcore.js"></script>    
<script type="text/javascript" src="/common/_lib/jqwidgets/jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="/common/_lib/jqwidgets/jqwidgets/jqxtree.js"></script>
<script type="text/javascript" src="/common/_lib/jqwidgets/jqwidgets/jqxwindow.js"></script>
<form name="form1" id="form1" method="post">	
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
</form>
<style>
//#tree-expand, #tree-collapse { display:inline-block;padding:5px;margin-right:5px;background-color:#e61e63;cursor:pointer;}
#tree-expand, #tree-collapse { display:inline-block;padding:5px;margin-right:5px;cursor:pointer;}
#tree-expand i, #tree-collapse i { color:#fff; } 
#window { display:none;}
</style>
<div id="window">
	<div id="windowHeader">
	    <span>메뉴 추가</span>
	</div>
	<div id="windowContent"></div>
</div>

	<table class="basic">
		<colgroup>
			<col style="width:250px" />
			<col style="width:*" />
		</colgroup>
		<tr>
			<th style="text-align:center">Menu</th>
			<th style="text-align:center"> Menu Detail </th>
		</tr>
		<tr>
			<td style="vertical-align:top" id="tree-wrap">
				<div class="buttonlist">
					<div class="left">
						<span class="ui_btn medium icon" id="root-tree-add"><span class="add"></span><input type="button" name="btnCol"  value="추가하기"/></span>
					</div>
					<div class="right">
					<!--
						<div id="tree-expand" title="전체열기"><i class="fa fa-plus"></i></div>
						<div id="tree-collapse" title="전체닫기"><i class="fa fa-minus"></i></div>
					-->
						<div id="tree-expand" title="전체열기"><font color="red" size="3">+</font></div>
						<div id="tree-collapse" title="전체닫기"><font color="red" size="3">-</font></div>
					</div>
				</div>
				<div id='menuWidget'  style="border:none;"></div>	
			</td>
			<td id="menuDetail" style="vertical-align:top">
			</td>
		</tr>
	</table>
	
	
<script type="x-underscore-template" id="tpl-menu-add">
<form name="menu-add-form">
<div class="buttonlist">
	<div class="right">
		<span class="ui_btn medium icon save-btn"><span class="save"></span><input type="button" name="btnCol"  value="저장"/></span>
	</div>
	<div class="left">
		부모아이디를 입력하지않으면 생성된 메뉴가 ROOT에 삽입됩니다 
	</div>
</div>
<div class="table_cover" style="margin-top:10px">
	<table class="basic">
	<tr>
		<th class="th2">메뉴 아이디</th>
		<td class="td2" colspan="3"><input type="text" class="text width_max" name="MENU_ID" value="<@= MENU_ID @>"/></td>
	</tr>
	<tr>
		<th>부모 메뉴 아이디(<@= PARENT_MENU_NAME @>)</th>
		<td colspan="3"><input type="text" class="text width_max" name="PARENT_ID" value="<@= PARENT_ID @>" /></td>
	</tr>
	<tr>
		<th>순번</th>
		<td colspan="3"><input type="text" class="text width_max" name="ORDER_NO" value="0"/></td>
	</tr>
	<tr>
		<th>메뉴명</th>
		<td colspan="3">한글:<input type="text" class="text" style="width:200px" name="MENU_NAME_KO" value=""/>&nbsp;<%=StringUtil.getLocaleWord("L.다국어코드", siteLocale) %><input type="text" class="text" style="width:200px" name="LANG_CODE" value=""/></td>
	</tr>
	<tr>
		<th style="width:100px">AIR_ACTION</th>
		<td colspan="3"><input type="text" class="text width_max" name="AIR_ACTION" value="" /></td>
	</tr>
	<tr>
		<th>AIR_MODE</th>
		<td colspan="3"><input type="text" class="text width_max" name="AIR_MODE" value=""/></td>
	</tr>
	<tr>
		<th colspan="4">
			<span class="ui_btn small icon"><span class="add"></span><a href="javascript:doAddRyu_1();">추가</a></span>
			<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:doDelRyu_1();">삭제</a></span>
			<input type="hidden" name="JSON_PARAMETER" val=""/>		
		</th>	
	</tr>
	<tbody id="tr_ryu_1">
	<tr data-meaning="ryuList10">
		<th class="th4">키값</th>
		<td class="td4"><input type="text" class="text" style="width:230px" data-meaning="key" value=""/></td>
		<th class="th4">value값</th>
		<td class="td4"><input type="text" class="text" style="width:230px" data-meaning="val" value=""/></td>
	</tr>
	</tbody>
	<tr>
		<th>권한 설정</th>
		<td colspan="3">
			<input type="hidden" name="READ_AUTHS" val=""/>
			<table class="basic">
				<colgroup>
				<col style="width:20%">
				<col style="width:5%">
				<col style="width:20%">
				<col style="width:5%">
				<col style="width:20%">
				<col style="width:5%">
				<col style="width:20%">
				<col style="width:5%">
				</colgroup>
				<tr>
<%if(CMM_USER_AUTH != null && CMM_USER_AUTH.getRowCount() > 0){
	for(int i=0; i < CMM_USER_AUTH.getRowCount(); i++){
		cnt++;
%>
					<th><%=CMM_USER_AUTH.getString(i, "name_ko")%></th><td style="padding:0;text-align:center"><input type="checkbox" data-meaning="READ_AUTH"   value="<%=CMM_USER_AUTH.getString(i, "code")%>"/></td>
	<%if(cnt%4 == 0){%>
				</tr>
				<tr>
<%}}}%>
				</tr>
			</table>
		</td>
	</tr>
	</table>
</div>
</form>
</script>


<script type="x-underscore-template" id="tpl-menu-detail">
<form name="menu-detail-form">
<input type="hidden" name="MENU_ID" value="<@= MENU_ID @>" />
<div class="buttonlist">
	<div class="left"><input type="checkbox" name="STATUS" id="STATUS_<@= MENU_ID @>" value="0" <@=STATUS==0 ? 'checked' : '' @>/><label for="STATUS_<@= MENU_ID @>">폐기</label></div>
	<div class="right">
		<span class="ui_btn medium icon" id="menu-save-btn"><span class="save"></span><input type="button" name="btnCol"  value="저장"/></span>
		<span class="ui_btn medium icon" id="menu-remove"><span class="delete"></span><input type="button" name="btnCol"  value="삭제"/></span>
	</div>
</div>

<div class="table_cover" style="margin-top:10px">
	<table class="basic" >
	<tr>
		<th class="th2">메뉴 아이디</th>
		<td class="td2" colspan="3"><@= MENU_ID @></td>
	</tr>
	<tr>
		<th>부모 아이디</th>
		<td colspan="3"><input type="text" class="text width_max" name="PARENT_ID" value="<@= PARENT_ID @>" /></td>
	</tr>
	<tr>
		<th>순번</th>
		<td colspan="3"><input type="text" class="text width_max" name="ORDER_NO" value="<@= ORDER_NO @>"/></td>
	</tr>
	<tr>
		<th>메뉴명</th>
		<td colspan="3">한글:<input type="text" class="text" style="width:200px" name="MENU_NAME_KO" value="<@=MENU_NAME_KO@>"/>&nbsp;<%=StringUtil.getLocaleWord("L.다국어코드", siteLocale) %><input type="text" class="text" style="width:200px" name="LANG_CODE" value="<@=LANG_CODE@>"/></td>
	</tr>
	<tr>
		<th style="width:100px">AIR_ACTION</th>
		<td colspan="3"><input type="text" class="text width_max" name="AIR_ACTION" value="<@= AIR_ACTION @>" /></td>
	</tr>
	<tr>
		<th>AIR_MODE</th>
		<td colspan="3"><input type="text" class="text width_max" name="AIR_MODE" value="<@= AIR_MODE @>"/></td>
	</tr>
	<tr>
		<th colspan="4">
			<span class="ui_btn small icon"><span class="add"></span><a href="javascript:doAddRyu();">추가</a></span>
			<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:doDelRyu();">삭제</a></span>	
			<input type="hidden" name="JSON_PARAMETER" val=""/>	
		</th>	
	</tr>
	<tbody id="tr_ryu">
<@_.each(JSON.parse(JSON_PARAMETER), function(v,i){ @>
	<tr data-meaning="ryuList<@=i@>">
		<th class="th4">키값</th>
		<td class="td4"><input type="text" class="text" style="width:230px" data-meaning="key" value="<@=v.key@>"/></td>
		<th class="th4">value값</th>
		<td class="td4"><input type="text" class="text" style="width:230px" data-meaning="val" value="<@=v.val@>"/></td>
	</tr>
<@	}); @>
	<tbody>
	<tr>
		<th>권한 설정</th>
		<td colspan="3">
			<input type="hidden" name="READ_AUTHS" val=""/>
			<table class="basic">
				<colgroup>
				<col style="width:20%">
				<col style="width:5%">
				<col style="width:20%">
				<col style="width:5%">
				<col style="width:20%">
				<col style="width:5%">
				<col style="width:20%">
				<col style="width:5%">
				</colgroup>
				<tr>
<%
cnt = 0;
if(CMM_USER_AUTH != null && CMM_USER_AUTH.getRowCount() > 0){
	for(int i=0; i < CMM_USER_AUTH.getRowCount(); i++){
		cnt++;
%>
					<th><%=CMM_USER_AUTH.getString(i, "name_ko")%></th><td style="padding:0;text-align:center"><input type="checkbox" data-meaning="READ_AUTH"   value="<%=CMM_USER_AUTH.getString(i, "code")%>" <@=_.indexOf(READ_AUTHS.split(","), '<%=CMM_USER_AUTH.getString(i, "code")%>') > -1 ? 'checked' : '' @>/></td>
	<%if((cnt)%4 == 0){%>
				</tr>
				<tr>
<%}}}%>
				</tr>
			</table>
		</td>
	</tr>
	</table>
</div>
</form>
</script>
<script type="text/javascript">
_.templateSettings = {
	interpolate: /\<\@\=(.+?)\@\>/gim,
	evaluate: /\<\@(.+?)\@\>/gim,
	escape: /\<\@\-(.+?)\@\>/gim
};
function newTreeSourceData(d) {
	 return {
		datatype:'json',
		datafields: [
			{name:'MENU_ID'},
			{name:'PARENT_ID'},
			{name:'ORDER_NO'},
			{name:'PARENT_ID'},
			{name:'MENU_NAME_KO'},
			{name:'MENU_NAME_EN'},
			{name:'AIR_ACTION'},
			{name:'AIR_MODE'},
			{name:'STATUS'},
			{name:'READ_AUTHS'},
			{name:'JSON_PARAMETER'}
		],
		localdata:d
	};
}
function reloadTree() {
	if ( $('#tree-wrap').find('#menuWidget').length > 0 ) {
		$('#menuWidget').jqxTree('destroy');
		$('#tree-wrap').append($('<div id="menuWidget" />').css('border','none'));
		$('#menuDetail').empty();
	}
	
	$.getJSON('ServletController?AIR_ACTION=SYS_MENU&AIR_MODE=ALL_LIST_MENU_JSON').success(function(d){
		// jqxwidget 이 event 발생시 해당 데이터에 접근이 불가능하므로 데이터 참조를 위한 해시맵을 만들었다 
		refData = (function() {
			var t0 = {};
			for (var i in d) t0[d[i].MENU_ID] = d[i];
			return t0;
		})();
		var source = newTreeSourceData(d);
        var dataAdapter = new $.jqx.dataAdapter(source);
        dataAdapter.dataBind();
        var records = dataAdapter.getRecordsHierarchy('MENU_ID', 'PARENT_ID', 'items', [{ name: 'MENU_NAME_<%=siteLocale%>', map: 'label'}]);
		function traverse(target, arr) { 
        	var data = arr || records;
        	var ul = $('<ul>');
        	for ( var i=0, n = data.length; i<n;i++ ) {
        		var li = $('<li />').text(data[i].MENU_NAME_<%=siteLocale%>).attr('data-mid', data[i].MENU_ID);
        		li.data('data', data[i]);
        		if ( data[i].items ) traverse(li, data[i].items)
        		ul.append(li);
        	}
        	target.append(ul);
        }
		
		traverse($('#menuWidget'), records);
	    $("#menuWidget").jqxTree({ width: '250px'}).show()
       .on('select', function (e) {
            var item = refData[$(e.args.element).attr('data-mid')];
            var tplSelector = '#tpl-menu-detail';
            var tpl = _.template($(tplSelector).html());
            $('#menu-save-btn, #menu-remove').off('click');
            $('#menuDetail').empty().append(tpl(item));
            $("form[name='menu-detail-form'] input[name='MENU_ID']").focusout(function() {
            	if ( !$(this).val() ) {
            		alert('필수값입니다.');
            		$(this).focus();
            		return;
            	}
            });
            $("form[name='menu-detail-form'] input[name='ORDER_NO']").focusout(function() {
       			var NUMBER_REGEXP = /^\s*(\-|\+)?(\d+|(\d*(\.\d*)))\s*$/;
       			if ( !NUMBER_REGEXP.test($(this).val()) ) {
       				alert("숫자만 입력가능합니다.");
       				$(this).focus();
       				return;
       			}
       		});
            $('#menu-save-btn').on('click', function(e) {
            	if ( !confirm('저장하시겠습니까?')) return; 
            	var setParameter = function(){
            		var frm = $("form[name='menu-detail-form']");
            		var k = frm.find($("[data-meaning='key']"));
        	 		var v = frm.find($("[data-meaning='val']"));
        	 		var r = frm.find($("[data-meaning='READ_AUTH']:checked"));
        	 		var json_param = [];
        	 		var read_auths = "";
        	 		k.each(function(i,val){
        	 			json_param.push({key:k.eq(i).val(),val:v.eq(i).val()});
        	 		});
        	 		$("input:hidden[name='JSON_PARAMETER']").val(JSON.stringify(json_param));
        	 		
        	 		r.each(function(i,val){
        	 			if(i > 0)read_auths += ",";
        	 			read_auths += $(this).val();
        	 		});
        	 		$("input:hidden[name='READ_AUTHS']").val(read_auths);
        	 	};
            	var data = (function() {
            		setParameter();
            		var t0 = $('form[name="menu-detail-form"]').serializeArray();
            		var result = {};
            		$.each(t0, function(i, v) { result[v.name] = v.value; });
            		return result;
            	})();
            	$.ajax({
            		url:'ServletController?AIR_ACTION=SYS_MENU&AIR_MODE=UPDATE_PROC_MENU',
        			data:{jsonData: JSON.stringify(data)},
            		method:'POST',
            		dataType:'html'
            	}).done(function(d) {
            		reloadTree();
            		alert('저장되었습니다.');
            	}).always(airCommon.hideBackDrop);
            });
        	$('#menu-remove').on('click', function(e) {
                var item = refData[$($('#menuWidget').jqxTree('selectedItem').element).attr('data-mid')];
                if ( $($('#menuWidget').jqxTree('getSelectedItem').element).find('li').length > 0 ) {
                	alert('빈 폴더만 삭제가 가능합니다.');
                	return;
                }
                if ( !confirm('삭제하시겠습니까?')) return; 

            	$.ajax({
            		url:'ServletController?AIR_ACTION=SYS_MENU&AIR_MODE=DELETE_PROC_MENU',
        			data:{menuId: item.MENU_ID},
            		method:'POST',
            		dataType:'html'
            	}).done(function(d) {
            		reloadTree();
            		alert('삭제되었습니다.');
            	}).always(airCommon.hideBackDrop);
        	});
	    });
	});
}
$(document).ready(function(){
	reloadTree();
	$('#tree-collapse').on('click', function(e) {
		$('#menuWidget').jqxTree('collapseAll');
	});
	$('#tree-expand').on('click', function(e) {
		$('#menuWidget').jqxTree('expandAll');
	})
	$('#listTabs-LIST').css('width','');
	$('#root-tree-add').on('click', function (e){
		$('#window').jqxWindow({
	         maxHeight: 700, maxWidth: 900, minHeight: 200, minWidth: 200, height: 500, width: 900,
	         initContent: function () {
	             $('#window').jqxWindow('focus');
	         }
	     }).jqxWindow('open');
	});
	$('#window').on('open', function(e) {
    	 // selected menu data
    	 var selectedEl = $('#menuWidget').jqxTree('getSelectedItem');
    	 var modelData = (function() {
    		 if ( selectedEl == null ) return { MENU_ID:airCommon.getRandomUUID(), PARENT_ID:'', PARENT_MENU_NAME:'ROOT' };
    		 else {
	   			 var data = refData[$(selectedEl.element).attr('data-mid')];
	   			 return {MENU_ID:airCommon.getRandomUUID(), PARENT_ID:data.MENU_ID, PARENT_MENU_NAME:data.MENU_NAME_<%=siteLocale%> };
    		 }
    	 })();
    	 var tpl = _.template($('#tpl-menu-add').html());
    	 $('#windowContent').empty().append(tpl(modelData));
    	 
         $("form[name='menu-add-form'] input[name='MENU_ID']").focusout(function() {
         	if ( !$(this).val() ) {
         		alert('필수값입니다.');
         		$(this).focus();
         		return;
         	}
         });
   		$("form[name='menu-add-form'] input[name='ORDER_NO']").focusout(function() {
   			var NUMBER_REGEXP = /^\s*(\-|\+)?(\d+|(\d*(\.\d*)))\s*$/;
   			if ( !NUMBER_REGEXP.test($(this).val()) ) {
   				alert("숫자만 입력가능합니다.");
   				$(this).focus();
   				return;
   			}
   		});
    	 $('.save-btn').click(function(e) {
    	 	if ( !$('form[name="menu-add-form"] input[name="MENU_NAME_<%=siteLocale%>"]').val() ) {
    	 		alert('메뉴 이름을 입력해주세요')
    	 		$('form[name="menu-add-form"] input[name="MENU_NAME_<%=siteLocale%>"]').focus();
    	 		return;
    	 	}
    	 	if ( !confirm("저장하시겠습니까? ") ) return;
			var setParameter = function(){
				var frm = $("form[name='menu-add-form']");
    	 		var k = frm.find($("[data-meaning='key']"));
    	 		var v = frm.find($("[data-meaning='val']"));
    	 		var r = frm.find($("[data-meaning='READ_AUTH']:checked"));
    	 		var json_param = [];
    	 		var read_auths = "";
    	 		k.each(function(i,val){
    	 			json_param.push({key:k.eq(i).val(),val:v.eq(i).val()});
    	 		});
    	 		$("input:hidden[name='JSON_PARAMETER']").val(JSON.stringify(json_param));
    	 		
    	 		r.each(function(i,val){
    	 			if(i > 0)read_auths += ",";
    	 			read_auths += $(this).val();
    	 		});
    	 		$("input:hidden[name='READ_AUTHS']").val(read_auths);
    	 	};
    	 	var menuAddFormData = (function() {
    	 		setParameter();
         		var t0 = $('form[name="menu-add-form"]').serializeArray();
         		var result = {};
         		$.each(t0, function(i, v) { result[v.name] = v.value; });
         		return result;
         	})();
        	$.ajax({
        		url:'ServletController?AIR_ACTION=SYS_MENU&AIR_MODE=WRITE_PROC_MENU',
    			data:{jsonData: JSON.stringify(menuAddFormData)},
        		method:'POST',
        		dataType:'html'
        	}).done(function(d) {
        		reloadTree();
        		$('#window').jqxWindow('close');
        	}).fail(function(e) {
        		alert('저장중 오류가 발생했습니다.' + e);
        	}).always(airCommon.hideBackDrop);
    	 });
     }).on('close', function(e) {
    	 airCommon.hideBackDrop;
    	 $('#windowContent').empty();
     });
});


//추가
function doAddRyu_1(){
	var rows = $("#tr_ryu_1 tr").length +1;
	var data = [{index:rows},];
	$("#addRyuTmpl_insert").tmpl(data).appendTo($("#tr_ryu_1"));
}
//삭제
function doDelRyu_1(){
	var index = $("#tr_ryu_1 tr").length;
	if(index > 1 ){
		$("[data-meaning=ryuList1"+index+"]").remove();
	}
}

//추가
function doAddRyu(){
	var rows = $("#tr_ryu tr").length +1;
	var data = [{index:rows},];
	$("#addRyuTmpl").tmpl(data).appendTo($("#tr_ryu"));
}
//삭제
function doDelRyu(){
	
	var tr = $("#tr_ryu tr");
	tr.eq($("#tr_ryu tr").length-1).remove();
}
</script>
<script id="addRyuTmpl" type="text/x-jquery-tmpl">
<tr data-meaning="ryuList\${index}">
   <th class="th4">키값</th>
   <td class="td4"><input type="text" class="text" style="width:230px" data-meaning="key" value=""/></td>
   <th class="th4">value값</th>
   <td class="td4"><input type="text" class="text" style="width:230px" data-meaning="val" value=""/></td>
</tr>
</script>
<script id="addRyuTmpl_insert" type="text/x-jquery-tmpl">
<tr data-meaning="ryuList1\${index}">
   <th class="th4">키값</th>
   <td class="td4"><input type="text" class="text" style="width:230px" data-meaning="key" value=""/></td>
   <th class="th4">value값</th>
   <td class="td4"><input type="text" class="text" style="width:230px" data-meaning="val" value=""/></td>
</tr>
</script>