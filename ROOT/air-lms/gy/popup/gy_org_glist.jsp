<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.01.05
  - 
  - @(#)
  - Description : 법무시스템 계약리스트
  --%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.lang.reflect.*"%>   
<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@page import="com.emfrontier.air.common.util.StringUtil" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = CommonProperties.getSystemDefaultLocale();

if (loginUser != null) {
	siteLocale = loginUser.getSiteLocale();
}

String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();
String CONTENT_PATH = (String)request.getAttribute(CommonConstants.CONTENT_PATH);
String popupContentName  = StringUtil.unescape(StringUtil.convertNull(request.getParameter("popupContentName")));


//-- 검색값 셋팅
BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
String pageNo               = requestMap.getString(CommonConstants.PAGE_NO);
String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
String callbackFunction		= requestMap.getString("CALLBACKFUNCTION");
String pum_en_dte			= requestMap.getDefStr("PUM_EN_DTE", "1900-01-01");
String callType				= requestMap.getString("CALLTYPE");

//-- 결과값 셋팅
BeanResultMap resultMap             = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);  

// 리스트 컬럼
boolean legalBCDFlag = loginUser.isUserAuth("LMS_BCD"); 

String actionCode           = resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode             = resultMap.getString(CommonConstants.MODE_CODE);
String contentName          = (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));


String jsonDataUrl = "/ServletController"
        + "?AIR_ACTION=LMS_GY_LIST_MAS"  
        + "&AIR_MODE=JSON_LIST";

String rdoAll = StringUtil.getLocaleWord("R.전체",siteLocale);
String rdoMyWork = StringUtil.getLocaleWord("R.나의업무",siteLocale);
// String rdoRec = StringUtil.getLocaleWord("R.접수대기",siteLocale);

String caption = StringUtil.getLocaleWord("L.체결계약서_조회",siteLocale);
if("IJ".equals(callType)){
	caption = StringUtil.getLocaleWord("L.계약품의_조회",siteLocale);;
}
%>
<!-- // Content // -->
<form id="form1" name="form1" method="post">
<input type="hidden" name="pum_en_dte__start" data-type="search" value="<%=pum_en_dte%>"/>
<input type="hidden" name="schgubun" data-type="search" value="AUTHS"/>
<p>   
    <table class="box">
    <caption><%=caption%></caption>
	    <tr>
	        <td class="corner_lt"></td><td class="border_mt"></td><td class="corner_rt"></td>
	    </tr>
	    <tr>
	        <td class="border_lm"></td>
	        <td class="body">
	            <table>
	                <colgroup>
	                    <col width="10%" />
	                    <col />
	                </colgroup>
	                <tr>
		                <th>
							<select name="TEXT_COL" data-type="search" class="select">
								<option value="GYEYAG_TIT"><%=StringUtil.getLocaleWord("L.계약명",siteLocale) %></option>
								<option value="GWANRI_NO"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale) %></option>
								<option value="GYEYAG_SANGDAEBANG_NAM"><%=StringUtil.getLocaleWord("L.계약상대방",siteLocale) %></option>
								<option value="YOCHEONG_NAM">체결 <%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></option>
								<option value="YOCHEONG_DPT_NAM">체결 <%=StringUtil.getLocaleWord("L.담당부서",siteLocale)%></option>
							</select>
						</th>
						<td>
							<input type="text" name="TEXT_VAL" id="TEXT_VAL" data-type="search" onkeydown="doSearch(document.form1, true)" maxlength="30" class="text width_max" />
						</td>
	                </tr>
	            </table>
	        </td>
	        <td class="border_rm"></td>
	    </tr>
	    <tr>
	        <td class="corner_lb"></td><td class="border_mb"></td><td class="corner_rb"></td>
	    </tr>                           
    </table> 
    
    <div class="buttonlist">
         <div class="right">
         	<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>  
         </div>                      
    </div>
    <br>
    <table id="gyeyagList" 
            style="width:auto;height:auto"> 
    <thead>
        <tr>
<!--             <th data-options="field:'CK',width:10,halign:'center',align:'center',checkbox:true"></th>
			<th data-options="field:'GY_OLD_UID',width:0,hidden:true"></th>  		  
			<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>  		  
			<th data-options="field:'GWANRI_NO',width:0,hidden:true"></th>  		  

			<th data-options="field:'HOESA_COD',width:0,hidden:true"></th>   -->
			
<!--             <th data-options="field:'CK',width:10,halign:'center',align:'center',checkbox:true"></th> -->
	         <th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>                 
	         <th data-options="field:'GY_OLD_UID',width:0,hidden:true"></th>                 
            <th data-options="field:'GYEYAG_TIT',width:300,halign:'center',align:'left'"><%=StringUtil.getLocaleWord("L.계약명",siteLocale)%></th>            
            <th data-options="field:'GWANRI_NO',width:100,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
            <th data-options="field:'GYEYAG_SANGDAEBANG_NAM',width:200,halign:'center',align:'left'"><%=StringUtil.getLocaleWord("L.계약상대방",siteLocale)%></th>            
            <th data-options="field:'YOCHEONG_DPT_NAM',width:120,halign:'center',align:'center'">체결 <%=StringUtil.getLocaleWord("L.담당부서",siteLocale)%></th>
<%--             <th data-options="field:'YOCHEONG_NAM',width:90,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale)%></th> --%>
<%--             <th data-options="field:'CHAMJOBUSEO_NAM',width:130,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.관련부서",siteLocale)%></th>  --%>
        </tr>
    </thead>
    </table>
<p></p>

</form>
<script type="text/javascript">

/**
 * 검색 수행
 */ 
function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
	
	$("#gyeyagList").datagrid("load", airCommon.getSearchQueryParams());
}


$(document).ready(function () {
    
	$('#listTabs-LIST').css('width','100%');
	$('#gyeyagList').datagrid({
		singleSelect:false,
		striped:true,
		fitColumns:true,
		rownumbers:true,
		multiSort:true,
		pagination:true,
		pagePosition:'bottom',	
		nowrap:false,
 		url:'<%=jsonDataUrl%>',
 		method:"post",				            	             
      	queryParams:airCommon.getSearchQueryParams(),
      	onBeforeLoad:function() { airCommon.showBackDrop(); },
      	onLoadSuccess:function() {
			airCommon.hideBackDrop(), airCommon.gridResize();
		},
		onLoadError:function() { airCommon.hideBackDrop(); },
	});
	$(window).bind('resize', airCommon.gridResize);
	
	
    $("#gyeyagList").datagrid({
        onCheck: function(index, row){
        	<%if(StringUtil.isNotBlank(callbackFunction)){%>
        	opener.<%=callbackFunction%>(JSON.stringify(row));
        	<%}else{%>
        	opener.$('input[name=lms_pati_org_gy_no]').val(row.GWANRI_NO);
        	opener.$('input[name=lms_pati_org_gy_uid]').val(row.SOL_MAS_UID);
        	opener.$('input[name=lms_pati_org_gy_title]').val(row.GYEYAG_TIT);
        	opener.$('input[name=lms_pati_org_gy_type]').val(row.GY_TYPE);
        	<%}%>
        	self.close();
        }
    });
    
});
</script>
