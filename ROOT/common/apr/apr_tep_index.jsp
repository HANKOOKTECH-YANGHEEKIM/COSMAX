<%--
  - Author : 강세원
  - Date : 2018.07.28
  - 
  - @(#)
  - Description : 결과 뷰 및 처리
  --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.emfrontier.air.common.util.StringUtil"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@page import="com.emfrontier.air.common.config.CommonProperties"%>
<%@page import="com.emfrontier.air.common.config.CommonConstants"%>
<%@page import="com.emfrontier.air.common.model.SysLoginModel"%>
<%@page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = CommonProperties.getSystemDefaultLocale();
if (loginUser != null) {
    siteLocale = loginUser.getSiteLocale();
}

String open_system = StringUtil.convertNull(request.getParameter("open_system"));

//-- 요청값 셋팅
BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
String sol_mas_uid		= requestMap.getString("SOL_MAS_UID");
String view_doc_mas_uid		= requestMap.getString("VIEW_DOC_MAS_UID");

//-- 결과값 셋팅
BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
SQLResults DATA_LIST = resultMap.getResult("DATA_LIST");
SQLResults LINE_TODO = resultMap.getResult("LINE_TODO");

BeanResultMap aprMap = new BeanResultMap();  
if(LINE_TODO != null && LINE_TODO.getRowCount() > 0)aprMap.putAll(LINE_TODO.getRowResult(0));
boolean isAuths = false;
if(loginUser.getLoginId().equals(aprMap.getString("APR_ID")) 
){
	isAuths = true;
}

%>
<div id="formAprViewPanels<%=sol_mas_uid%>">
<%
boolean isNextForm = false;
String last_doc_uid = "";
String next_form_no = "";
String next_form_nm = "";
String collapsibleYn = "";
if(DATA_LIST != null && DATA_LIST.getRowCount() > 0){
	for(int i=0; i < DATA_LIST.getRowCount(); i++){
		String doc_johoe_auth_codes 	= DATA_LIST.getString(i, "DOC_JOHOE_AUTH_CODES");
		String iparam_doc_mas_uid 		= DATA_LIST.getString(i, "DOC_MAS_UID");
		String munseo_seosig_no 		= DATA_LIST.getString(i, "MUNSEO_SEOSIG_NO");
		String iparam_munseo_seosig_nam = DATA_LIST.getString(i, "MUNSEO_SEOSIG_NAM_"+ siteLocale);
		String group_uid		 		= DATA_LIST.getString(i, "GROUP_UID");
		
		//문서 조회 권한
		boolean isJohoeAuthYn = false;
	
		if(loginUser.isUserAuth(doc_johoe_auth_codes)){
			isJohoeAuthYn = true;
		}
		
		if(!isJohoeAuthYn){
			iparam_munseo_seosig_nam += " - 열람권한없음";
		}
		
		if(i == (DATA_LIST.getRowCount()-1)) {
			last_doc_uid = iparam_doc_mas_uid;
		}

		// 문서 조회 권한별 열림 설정
	    if(isJohoeAuthYn){
	    	collapsibleYn = "true";
	    	
	    	 // 마지막 문서만 열린 상태로 설정
	    	if(i < DATA_LIST.getRowCount() - 1) {
	        	collapsibleYn = "true";
	        } else {
	        	collapsibleYn = "false";
	        }
	    }else{
	    	collapsibleYn = "true";
	    }
    	if(view_doc_mas_uid.equals(iparam_doc_mas_uid)){
	    	collapsibleYn = "false";
    	}
	    
		String onLoadFn = "";
	    String href = "/ServletController?AIR_ACTION=SYS_FORM";
		href += "&AIR_MODE=VIEW_FORM_ONE";


		href += "&group_uid="+group_uid;
		href += "&sol_mas_uid="+sol_mas_uid;
		href += "&doc_mas_uid="+iparam_doc_mas_uid;
		href += "&munseo_seosig_no="+munseo_seosig_no;
%>
		<div id="accordion-<%=munseo_seosig_no%>" title="<%=iparam_munseo_seosig_nam%>" class="easyui-panel" style="padding:5px" data-options="href:'<%=href %>'<%=onLoadFn %>,collapsible:true,collapsed:<%=collapsibleYn%>"> </div>
<%		
	}
}

%>
</div>

<%if(LINE_TODO != null && LINE_TODO.getRowCount() > 0){ %>
<br/>
<br/>
<br/>
<script>
	//-- 결재 처리
	var doAprProc<%=sol_mas_uid%> = function(){
<%-- 		var msg = $("input:radio[name='apr_stu']:checked").attr("title")+"<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale)%>"; --%>
		var msg = $("input:radio[name='apr_stu']:checked").attr("title")+" 하시겠습니까?";
		if(confirm(msg)){
			airCommon.showBackDrop();
			
			//--에디터 서브밋 처리
			airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
			
			var data = $("#aprProcForm<%=sol_mas_uid%>").serialize();
			airCommon.callAjax("SYS_APR", "APR_CFM_PROC",data, function(json){
				alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", siteLocale, "B.처리")%>");
				if(opener){
					airCommon.hideBackDrop();
				<%if("LG_APPR".equals(open_system)){%>
					
					try{
						var url = "<%=CommonProperties.load("aprv.url")%>";
						window.location.href = url;
					}catch(e){
						
					}
				
				<%}else{%>
					try{
						//--그리드 리스트 refresh
						opener.doSearch(opener.document.form1);
					}catch(e){
						try{
							//-- 메인 화면 refresh
							opener.initMain();
						}catch(e){
							
						}
					}
					
					window.close();
				<%}%>
					
				}
			});
		}
	}
	//-- 패널 로드가 완료 되면 결재의 처리 버튼으로 스크롤 이동
	var setLoadPanel = function(){
		setTimeout(function(){
	        var offset = $("#apr_proc_btn").offset();
	        $('html, body').animate({scrollTop : offset.top}, 500);
		}, 200);
	}
	$(function(){
	});

	
</script>
<form name="aprProcForm<%=sol_mas_uid%>" id="aprProcForm<%=sol_mas_uid%>">
<input type="hidden" name="apr_no" value="<%=LINE_TODO.getString(0, "APR_NO") %>" />
<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid %>" />
<input type="hidden" name="doc_mas_uid" value="<%=LINE_TODO.getString(0, "DOC_MAS_UID") %>" />
<input type="hidden" name="apr_line_uid" value="<%=LINE_TODO.getString(0, "APR_LINE_UID") %>" />
<input type="hidden" name="apr_seq_no" value="<%=LINE_TODO.getString(0, "APR_SEQ_NO") %>" />
<input type="hidden" name="apr_type" value="<%=LINE_TODO.getString(0, "APR_TYPE") %>" />
<input type="hidden" name="apr_id" value="<%=LINE_TODO.getString(0, "APR_ID") %>" />
<input type="hidden" name="apr_nm" value="<%=LINE_TODO.getString(0, "APR_NM") %>" />
<input type="hidden" name="apr_dpt_cd" value="<%=LINE_TODO.getString(0, "APR_DPT_CD") %>" />
<input type="hidden" name="apr_dpt_nm" value="<%=LINE_TODO.getString(0, "APR_DPT_NM") %>" />
<input type="hidden" name="stu_gbn" value="<%=LINE_TODO.getString(0, "STU_GBN") %>" />
<input type="hidden" name="stu_id" value="<%=LINE_TODO.getString(0, "STU_ID") %>" />
<table class="basic">
<caption><%=StringUtil.getLocaleWord("L.결재의견",siteLocale) %> </caption>
<tr>
	<th class="th4"><%=StringUtil.getLocaleWord("L.결재구분",siteLocale) %> </th>
	<td class="td4" colspan="3">
		<%=HtmlUtil.getInputRadio(request, true, "apr_stu", "Y|" + StringUtil.getLocaleWord("L.승인",siteLocale) + "^R|" + StringUtil.getLocaleWord("L.반려",siteLocale) + "", "Y", "", "")%>			
	</td>
</tr>
<tr>
	<th class="th4"><%=StringUtil.getLocaleWord("L.결재자",siteLocale) %> </th>
	<td class="td4"><%=LINE_TODO.getString(0, "APR_NM")%></td>
	<th class="th4"><%=StringUtil.getLocaleWord("L.소속부서",siteLocale) %> </th>
	<td class="td4"><%=LINE_TODO.getString(0, "APR_DPT_NM")%></td>
</tr>	
<tr>
	<th class="th4"><%=StringUtil.getLocaleWord("L.의견",siteLocale) %></th>
	<td class="td4" colspan="3">
		<textarea class="memo width_max" name="apr_memo" id="apr_memo" maxlength="600"></textarea>
	</td>
</tr>
</table>
<div class="buttonlist" id="apr_proc_btn">
    <div class="left">
    </div>
    <div class="rigth">
<%if(isAuths){ %>
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="updateDoc();"><%=StringUtil.getLocaleWord("L.내용수정",siteLocale)%></a></span>
<%} %>
<script type="text/javascript">
<%if(isAuths){ %>
var updateDoc = function(){
	airCommon.openDocUpdate("<%=last_doc_uid%>","<%=sol_mas_uid%>","<%=LINE_TODO.getString(0, "APR_NO") %>", 'GYEOL');
}
<%} %>

</script>
    	<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doAprProc<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.처리",siteLocale)%></a></span>
    </div>
</div>
</form>
<%} %>
<script>
<%-- 팝업으로 열릴때 세로 스크롤바 때문에 버튼이 짤려 보이는 부분을 방지하기 위한 방어 코드--%>
if(opener){
	<%-- $("#tepIndexLayer").css("padding-right","15px");--%>
	$("body").css("overflow","scroll");
}else if(parent.opener){
}
</script>