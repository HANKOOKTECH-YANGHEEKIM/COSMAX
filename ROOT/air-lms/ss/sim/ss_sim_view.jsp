<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);

	String sol_mas_uid = requestMap.getString("SOL_MAS_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults rsMas = resultMap.getResult("SS_SIM");
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	BeanResultMap simMap = new BeanResultMap();
	if(rsMas != null && rsMas.getRowCount()> 0){
		simMap.putAll(rsMas.getRowResult(0));
	}
	
	String doc_mas_mode_code	= request.getParameter("doc_mas_mode_code");
	String doc_mas_uid			= request.getParameter("doc_mas_uid");
	String new_doc_mas_uid	= request.getParameter("new_doc_mas_uid");
	String munseo_seosig_no	= request.getParameter("munseo_seosig_no");
	
	// 각종 코드정보문자열 셋팅
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMSSS002_SIM_LIST"), "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String PROG_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("PROG_LIST"), "CODE,LANG_CODE", "");
	String SEONGO_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SEONGO_LIST"), "CODE,LANG_CODE", "");
	String GYEOLGWA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GYEOLGWA_LIST"), "CODE,LANG_CODE", ""); //소송결과
	
	String att_master_doc_id = simMap.getString("SS_SIM_UID");
	
	SQLResults rsSs			= resultMap.getResult("SS_MAS");
	BeanResultMap masMap = new BeanResultMap();  

	if(rsSs != null && rsSs.getRowCount() > 0)masMap.putAll(rsSs.getRowResult(0));
	boolean isAuths = false;
	if(loginUser.getLoginId().equals(masMap.getString("DAMDANGJA_ID")) ||
			loginUser.isUserAuth("LMS_SSM") ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
%>

<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.심급기본정보",siteLocale) %></caption>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.심급",siteLocale) %></th>
		<td class="td4" colspan="3">
			<%=simMap.getString("SIM_NAM")%>
		</td>
	</tr>	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.관할법원",siteLocale) %></th>
		<td class="td4"><%=StringUtil.convertForView(simMap.getString("BEOBWEON_NAM"))%></td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.사건번호",siteLocale) %>/<%=StringUtil.getLocaleWord("L.사건명",siteLocale) %></th>
		<td class="td4"><%=StringUtil.convertForView(simMap.getString("SAGEON_NO")) %>
		<%if(!"".equals(StringUtil.convertForView(simMap.getString("SAGEON_NO"))) || (StringUtil.convertForView(simMap.getString("SAGEON_NO"))).length() > 0) {%>
		/
		<%} %>
		<%=StringUtil.convertForView(simMap.getString("SAGEON_TIT")) %></td>
	</tr>
	
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.종국일자",siteLocale) %></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, false, "SEONGO_DTE", "SEONGO_DTE", simMap.getString("SEONGO_DTE"), "") %>
		</td>
		<th class="th4"></span><%=StringUtil.getLocaleWord("L.종국결과",siteLocale) %></th>
		<td class="td4">
			<%=StringUtil.convertForView(simMap.getString("GYEOLGWA_VAL")) %>
		</td>
	</tr>
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.접수일",siteLocale) %></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, false, "SOJEGI_DTE", "SOJEGI_DTE", simMap.getString("SOJEGI_DTE"), "") %>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.불복마감일",siteLocale) %></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, false, "SANGSO_DTE", "SANGSO_DTE", simMap.getString("SANGSO_DTE"), "") %>
		</td>
	</tr>
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.원고대리인",siteLocale) %></th>
		<td class="td4">
			<%=StringUtil.convertForView(simMap.getString("WEONGO_DAERIIN")) %>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.피고대리인",siteLocale) %></th>
		<td class="td4">
			<%=StringUtil.convertForView(simMap.getString("SANGDAE_DAERIIN")) %>
		</td>
	</tr>
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.대리인평가내용",siteLocale) %></th>
		<td colspan="3">
			<textarea class="memo width_max" name="PANGYEOL_CONT" id="PANGYEOL_CONT" readonly="readonly" onblur="airCommon.validateMaxLength(this, 4000)" style="height:100px;"><%=simMap.getStringEditor("PANGYEOL_CONT") %></textarea>
		</td>
	</tr>
	 <tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.판결_합의_종결문서",siteLocale) %></th>			
		<td class="td4">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/JUDGMENT" name="typeCode" />
			</jsp:include>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.답변서_준비서면",siteLocale) %></th>			
		<td class="td4">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/ANSWER" name="typeCode" />
			</jsp:include>
		</td>
	</tr>
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.소장",siteLocale) %></th>			
		<td class="td4">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/SOJANG" name="typeCode" />
			</jsp:include>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부",siteLocale) %></th>			
		<td class="td4">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/SIM_START" name="typeCode" />
			</jsp:include>
		</td>
	</tr>
</table>

<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<script>
			function goSimStartModify<%=sol_mas_uid%>() {		
				var url = "/ServletController";
				url += "?AIR_ACTION=LMS_SS_MAS";
				url += "&AIR_MODE=SIM_START_WRITE_FORM";
				url += "&SOL_MAS_UID=<%=sol_mas_uid%>";
				url += "&SS_SIM_UID=<%=simMap.getString("SS_SIM_UID")%>";
				url += "&UPDATE_YN=Y";
				
				airCommon.openWindow(url, "1024", "680", "POPUP_WRITE_FORM", "yes", "yes", "");		
		}		
		</script>
<%

%>
    	<script>
			function goSimStartDelete<%=sol_mas_uid%>() {
			
				var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>";
				if(confirm(msg)){
					var data = {};
					data["SOL_MAS_UID"] = "<%=sol_mas_uid%>";
					data["SS_SIM_UID"] = "<%=simMap.getString("SS_SIM_UID")%>";
					
					airCommon.callAjax("LMS_SS_MAS", "SIM_START_DELETE_PROC",data, function(json){
						<%-- $("#accordion-SimView<%//=sol_mas_uid%>").panel('close','<%//=simMap.getString("SS_SIM_UID")%>'); --%>
						//doSearch();
// 						$("#listTabsLayer").tabs('getSelected').panel('refresh');

						//-- 임시저장이면서 팝업상태이면 닫지 않고 TEP를 띄워 준다.
						refreshWindow();
					});
				}
			}
		</script>
<%
	//}
%>
<%
	if("".equals(simMap.getString("PROG_COD"))) {
%>
    	<script>
			function goSimEndWrite<%=sol_mas_uid%>() {		
				var url = "/ServletController";
				url += "?AIR_ACTION=LMS_SS_MAS";
				url += "&AIR_MODE=SIM_END_WRITE_FORM";
				url += "&SOL_MAS_UID=<%=sol_mas_uid%>";
				url += "&SS_SIM_UID=<%=simMap.getString("SS_SIM_UID")%>";
				
				airCommon.openWindow(url, "1024", "550", "POPUP_WRITE_FORM", "yes", "yes", "");		
		}
		</script>
		<%-- <span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goSimEndWrite<%//=sol_mas_uid%>();"><%//=StringUtil.getLocaleWord("B.심급종결정보등록",siteLocale)%></a></span> --%>
<%
	}
%>
    </div>
</div>


<%
	
%>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<script>
			function goSimEndModify<%=sol_mas_uid%>() {		
				var url = "/ServletController";
				url += "?AIR_ACTION=LMS_SS_MAS";
				url += "&AIR_MODE=SIM_END_WRITE_FORM";
				url += "&SOL_MAS_UID=<%=sol_mas_uid%>";
				url += "&SS_SIM_UID=<%=simMap.getString("SS_SIM_UID")%>";
				
				airCommon.openWindow(url, "1024", "550", "POPUP_WRITE_FORM", "yes", "yes", "");		
		}		
		</script>

    	<script>
			function goSimEndDelete<%=sol_mas_uid%>() {		
				var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>";
				if(confirm(msg)){
					var data = {};
					data["SOL_MAS_UID"] = "<%=sol_mas_uid%>";
					data["SS_SIM_UID"] = "<%=simMap.getString("SS_SIM_UID")%>";
					
					airCommon.callAjax("LMS_SS_MAS", "SIM_END_DELETE_PROC",data, function(json){
						opener.doSearch();
						refreshWindow();
					});
				}
			}
		</script>
		
		<% if(!"Y".equals(simMap.get("STU_ID_YN"))  
				&& ((loginUser.getUserNo().equals(masMap.getString("DAMDANGJA_ID"))) || loginUser.getAuthCodes().contains("CMM_SYS"))
			){ %>
			<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goSimStartModify<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.심급정보수정",siteLocale)%></a></span>
			<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:goSimStartDelete<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.심급정보삭제",siteLocale)%></a></span>	
		<%}%>
		
		<%-- <span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goSimEndModify<%//=sol_mas_uid%>();"><%//=StringUtil.getLocaleWord("B.심급종결정보수정",siteLocale)%></a></span>&nbsp; --%>
		<%-- <span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:goSimEndDelete<%//=sol_mas_uid%>();"><%//=StringUtil.getLocaleWord("B.심급종결정보삭제",siteLocale)%></a></span> --%>
<%--} --%>

    </div>
</div>

<br />
<table class="list" id="ssSimGwanryeonList<%=sol_mas_uid%>">
	<caption class="title">
		<%=StringUtil.getLocaleWord("L.진행내역", siteLocale) %>
		<div style="float:right;">
			<span class="ui_btn small icon" style="float: right;"><span class="add"></span><a href="javascript:goGwanryeonAdd()" ><%=StringUtil.getLocaleWord("B.ADD",siteLocale)%></a></span>
		</div>
	</caption>
	<colgroup>
		<col width="10%" />
		<col width="*" />
		<!-- <col width="20%" /> -->
	</colgroup>
	<thead>
 	<tr>
		<th><%=StringUtil.getLocaleWord("L.일자", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.내역", siteLocale) %></th>
		<%-- <th><%//=StringUtil.getLocaleWord("L.첨부파일", siteLocale) %></th> --%>
	</tr>
	</thead>
	<tbody id="ssSimGwanryeonList<%=sol_mas_uid%>Body"></tbody>
</table>

<br />
<table class="list" id="ssSimBiyongList<%=sol_mas_uid%>">
	<caption class="title">
		<%=StringUtil.getLocaleWord("L.비용내역", siteLocale) %>
		<div style="float:right;">
			<span class="ui_btn small icon" style="float: right;"><span class="add"></span><a href="javascript:goBiyongAdd()" ><%=StringUtil.getLocaleWord("B.ADD",siteLocale)%></a></span>
		</div>
	</caption>
	<colgroup>
		<col style="width:10%;" />
		<col style="width:15%;" />
		<col style="width:auto;" />
		<!-- <col style="width:15%;" /> -->
	</colgroup>
	<thead>
	
 	<tr>
		<%-- <th><%//=StringUtil.getLocaleWord("L.선택", siteLocale) %></th> --%>
		<th><%=StringUtil.getLocaleWord("L.입/출금일", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.지급금액", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.내역", siteLocale) %></th>
		<%-- <th><%//=StringUtil.getLocaleWord("L.첨부파일", siteLocale) %></th> --%>
	</tr>
	</thead>
	<tbody id="ssSimBiyongList<%=sol_mas_uid%>Body"></tbody>
</table>

<%
	
%>
<%
//}
%>

<script>
var goNewSimWrite<%=sol_mas_uid%> = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_SS_MAS";
	url += "&AIR_MODE=SIM_START_WRITE_FORM";	
	url += "&SOL_MAS_UID=<%=sol_mas_uid %>";
	
	airCommon.openWindow(url, "1024", "500", "POPUP_WRITE_FORM", "yes", "yes", "");		
};

var goSimView<%=sol_mas_uid%> = function(vSS_SIM_UID) {
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_SS_MAS";
	url += "&AIR_MODE=SIM_VIEW";	
	url += "&SOL_MAS_UID=<%=sol_mas_uid %>";
	url += "&SS_SIM_UID="+vSS_SIM_UID;
	
	
	if($("#accordion-SimView<%=sol_mas_uid%>").length == 0){
		var div = $("<div class=\"easyui-panel\">").attr("id","#accordion-SimView<%=sol_mas_uid%>").css("padding","5px");
		$('#divSimView<%=sol_mas_uid%>').append(div);
	}
	
	var title = "<%=StringUtil.getLocaleWord("L.심급상세정보", siteLocale) %>";
	$("#accordion-SimView<%=sol_mas_uid%>").panel({
		href:url,
		title:title,
		collapsible:true,
		collapsed:false
	});
};

//-- 진행 내역
//-- 비용 목록
var getSimGwanryeonList<%=sol_mas_uid%> = function(){
	var data = {};
	data["sol_mas_uid"]="<%=sol_mas_uid%>";
	data["ss_sim_uid"] = "<%=simMap.getString("SS_SIM_UID")%>";
	data["sim_cha_no__gt"] = "0";
  	
	airCommon.callAjax("<%=actionCode%>", "SIM_GWANRYEON_JSON_LIST",data, function(json){
		setSimGwanryeonList<%=sol_mas_uid%>(json);
	});
};

var setSimGwanryeonList<%=sol_mas_uid%> =  function(data, ss_sim_uid){
	
	$("#ssSimGwanryeonList<%=sol_mas_uid%>Body tr").remove(); // 기존 데이터 삭제
	
	if(data.RESULT === "NO_RESULT"){
		return false;
	}
	var arrData = data.rows;

   	//jquery-tmpl
   	var tgTbl = $("#ssSimGwanryeonList<%=sol_mas_uid%>Body");
	$("#ssSimGwanryeonListRowTemplate").tmpl(arrData).appendTo(tgTbl);
};



//-- 비용 목록
var getSimBiyongList<%=sol_mas_uid%> = function(){
	var data = {};
	data["sol_mas_uid"]="<%=sol_mas_uid%>";
	data["ss_sim_uid"] = "<%=simMap.getString("SS_SIM_UID")%>";
	data["sim_cha_no__gt"] = "0";
  	
	airCommon.callAjax("<%=actionCode%>", "SIM_BIYONG_JSON_LIST",data, function(json){
		setSimBiyongList<%=sol_mas_uid%>(json);
	});
};

var setSimBiyongList<%=sol_mas_uid%> =  function(data, ss_sim_uid){
	
	$("#ssSimBiyongList<%=sol_mas_uid%>Body tr").remove(); // 기존 데이터 삭제
	
	if(data.RESULT === "NO_RESULT"){
		return false;
	}
	var arrData = data.rows;

   	//jquery-tmpl
   	var tgTbl = $("#ssSimBiyongList<%=sol_mas_uid%>Body");
	$("#ssSimBiyongListRowTemplate").tmpl(arrData).appendTo(tgTbl);
};


var refreshTab = function(title){
	$('#tepIndexOptLayer').tabs('getTab',title).panel('refresh');
}

var refreshWindow = function(){
	
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("LMS_SS_MAS"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_INDEX"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.attr("target","_self");
	imsiForm.appendTo("body");
	imsiForm.submit();
}

//리사이징 처리
$(window).resize(function(){
// 	 $(".easyui-accordion").each(function(){
// 		 $(this).accordion('resize');
// 	 });
});
<%-- 팝업으로 열릴때 세로 스크롤바 때문에 버튼이 짤려 보이는 부분을 방지하기 위한 방어 코드--%>
if(opener){
	<%-- $("#tepIndexLayer").css("padding-right","15px");--%>
	$("body").css("overflow","scroll");
}else if(parent.opener){
}

$(function(){
	getSimGwanryeonList<%=sol_mas_uid%>();
	getSimBiyongList<%=sol_mas_uid%>();
	
	$(window).resize(function() {
		$('.easyui-panel').panel('resize');
		$(".easyui-tabs").tabs('resize');
	});
});

</script>

<script type="text/javascript">

	function goGwanryeonAdd(SS_GWANRYEON_UID) {
		
		var url = "/ServletController";
		url += "?AIR_ACTION=LMS_SS_MAS";
		url += "&AIR_MODE=POPUP_WRITE_GWANRYEON_FORM";
		url += "&SIM_CHA_NO=<%=simMap.getString("SIM_CHA_NO")%>";
		url += "&SOL_MAS_UID=<%=sol_mas_uid%>";
		url += "&SS_SIM_UID=<%=simMap.getString("SS_SIM_UID")%>";
		url += "&SS_GWANRYEON_UID=" + SS_GWANRYEON_UID;
		
		airCommon.openWindow(url, "600", "400", "POPUP_WRITE_GWANRYEON_FORM", "yes", "yes", "");		
		
	}

	function goBiyongAdd(SS_BIYONG_UID) {
		
		var url = "/ServletController";
		url += "?AIR_ACTION=LMS_SS_MAS";
		url += "&AIR_MODE=POPUP_WRITE_BIYONG_FORM";
		url += "&SIM_CHA_NO=<%=simMap.getString("SIM_CHA_NO")%>";
		url += "&SOL_MAS_UID=<%=sol_mas_uid%>";
		url += "&SS_SIM_UID=<%=simMap.getString("SS_SIM_UID")%>";
		url += "&SS_BIYONG_UID=" + SS_BIYONG_UID;
		
		airCommon.openWindow(url, "600", "400", "POPUP_WRITE_BIYONG_FORM", "yes", "yes", "");		
		
	}
	
</script>	

<script id="ssSimGwanryeonListRowTemplate" type="text/html">
    <tr id="\${SS_GWANRYEON_UID}" onclick="goGwanryeonAdd('\${SS_GWANRYEON_UID}');" style="cursor:pointer;">
        <td style="text-align:center;">\${JAGSEONG_DTE}</td>
		<%-- 20191111 관리번호 CM2019-0001 --%>
        <%--<td style="text-align:center;">\${JARYOGAEYO}</td>--%>
		<td>{{html airCommon.convertForView(JARYOGAEYO)}}</td>
    </tr>
</script>

<script id="ssSimBiyongListRowTemplate" type="text/html">
    <tr id="\${SS_BIYONG_UID}" onclick="goBiyongAdd('\${SS_BIYONG_UID}');" style="cursor:pointer;">
        <td style="text-align:center;">\${JIGEUB_DTE}</td>
		<td style="text-align:center;">\${JIGEUB_COST01} (\${JIGEUB_GUBUN})</td>
		<%-- 20191111 관리번호 CM2019-0001 --%>
        <%--<td style="text-align:center;">\${NAEYEOK}</td>--%>
		<td>{{html airCommon.convertForView(NAEYEOK)}}</td>	
    </tr>
</script>

