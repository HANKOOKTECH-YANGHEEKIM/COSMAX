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
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	String sol_mas_uid = requestMap.getString("SOL_MAS_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults YUHYEONG02_LIST = resultMap.getResult("YUHYEONG02_LIST");
	SQLResults		rsMas = resultMap.getResult("SS_MAS");
	
	BeanResultMap masMap = new BeanResultMap();
	if(rsMas != null && rsMas.getRowCount()> 0){
		masMap.putAll(rsMas.getRowResult(0));
	}
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();

	// 각종 코드정보문자열 셋팅
	String BANSO_YN_CODESTR = LmsUtil.getYnCodStr();
	String JUNGYO_YN_CODESTR = LmsUtil.getYnCodStr();
	
	String GUBUN1_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUBUN_LIST"), "CODE_ID,LANG_CODE", "");
	String YUHYEONG01_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("YUHYEONG01_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE",  "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String DANGSAJA_JIWI_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("DANGSAJA_JIWI_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String strCurGubunList = StringUtil.getCodestrFromSQLResults(resultMap.getResult("CUR_LIST"), "CODE,NAME_"+ siteLocale, "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));// + "^SJ/HJ|심급/확정종결";
	
	String YUHYEONG02_CODESTR = "";
	if(YUHYEONG02_LIST != null && YUHYEONG02_LIST.getRowCount() > 0){
		YUHYEONG02_CODESTR = StringUtil.getCodestrFromSQLResults(YUHYEONG02_LIST, "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	}else{
		YUHYEONG02_CODESTR = "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale);
	}
	
	boolean isAuths = false;
	if(loginUser.getLoginId().equals(masMap.getString("DAMDANGJA_ID")) ||
			loginUser.isUserAuth("LMS_SSM") ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
%>
<table class="basic">
	<caption>
		<%=StringUtil.getLocaleWord("L.기본정보",siteLocale)%>
		<div style="float:right;">
			<span class="ui_btn small icon"><span class="print"></span><a href="javascript:void(0)" onclick="window.print();"><%=StringUtil.getLocaleWord("B.PRINT",siteLocale)%></a></span>
		</div>
	</caption>
	<%--
	<tr>
	    <th class="th2"><%//=StringUtil.getLocaleWord("L.상대방",siteLocale)%></th>
		<td class="td2" colspan ="3">
			<%//=masMap.getStringView("SANGDAEBANG")%>
        </td>
    </tr>
     --%>
	<tr>
	    <th class="th2"><%=StringUtil.getLocaleWord("L.사건명",siteLocale)%></th>
		<td class="td2" colspan ="3">
		    <%=StringUtil.convertForView(masMap.get("SAGEON_TIT"))%>
        </td>
    </tr>
    <tr>
	    <th class="th2"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td>
			<%=masMap.getString("HOESA_NAM") %>
		</td>
		<th class="th2"><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></th>
		<td class="td2">
			<%=masMap.getString("YUHYEONG_NAM") %>
		</td>
    </tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.권리자",siteLocale)%></th>
		<td class="td4">
			<%=StringUtil.convertForView(masMap.getString("GWONRIJA"))%>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.출원번호",siteLocale)%></th>
		<td class="td4">
			<%=StringUtil.convertForView(masMap.getString("CHURWONBEONHO"))%>
		</td>
	</tr>
	<tr>
		<th><%=StringUtil.getLocaleWord("L.원고", siteLocale) %></th>
		<td class="td4"><%=StringUtil.convertForView(masMap.getString("WEONGO_NM"))%></td>
		
		<th><%=StringUtil.getLocaleWord("L.피고", siteLocale) %></th>
		<td class="td4"><%=StringUtil.convertForView(masMap.getString("PIGO_NM"))%></td>
	</tr>
	<tr>
		<th><%=StringUtil.getLocaleWord("L.제품명", siteLocale) %></th>
		<td class="td4"><%=StringUtil.convertForView(masMap.getString("JEPUMMYEONG"))%></td>
		<th><%=StringUtil.getLocaleWord("L.등록번호", siteLocale) %></th>
		<td class="td4"><%=StringUtil.convertForView(masMap.getString("DEUNGNOKBEONHO"))%></td>
	</tr>
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.소송가액",siteLocale) %></th>
		<td class="td4">
			<%=StringUtil.getFormatCurrency(masMap.getString("SOSONGGA_COST"),-1) %>
			(<%=HtmlUtil.getSelect(request,false, "SOSONGGA_GUBUN", "SOSONGGA_GUBUN", strCurGubunList, masMap.getDefStr("SOSONGGA_GUBUN","KRW"), "class=\"select \" ") %>)
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.종결여부",siteLocale) %></th>
		<td class="td4">
			<%if("Y".equals(masMap.getString("STU_ID_YN"))){ %>
				<%=StringUtil.getLocaleWord("L.업무현황_종결",siteLocale) %>
			<%}else{ %>
			<%} %>
		</td>
	</tr>
	
	<tr>
	    <th class="th2"><%=StringUtil.getLocaleWord("L.사건개요",siteLocale)%></th>
		<td class="td2" colspan="3">
		    <%=masMap.getStringView("SAGEONGAEYO")%>
        </td>
    </tr>
	<tr>
	    <th class="th2"><%=StringUtil.getLocaleWord("L.비고",siteLocale)%></th>
		<td class="td2" colspan ="3">
		    <%=masMap.getStringView("BIGO")%>
        </td>
    </tr>
</table>
<%if(!"Y".equals(masMap.getString("STU_ID_YN"))){ %>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<script>
			function goMasModify<%=sol_mas_uid%>(defDocMainUid, docMasUid) {		
				var url = "/ServletController";
				url += "?AIR_ACTION=LMS_SS_MAS";
				url += "&AIR_MODE=MAS_WRITE_FORM";
				url += "&SOL_MAS_UID=<%=sol_mas_uid%>";
				url += "&DOC_MAS_UID=<%=jsonMap.getString("DOC_MAS_UID")%>";
				
				airCommon.openWindow(url, "1024", "550", "POPUP_WRITE_FORM", "yes", "yes", "");		
		}		
		</script>
		
		<%if((!"Y".equals(masMap.getString("STU_ID_YN"))
				&& (loginUser.getUserNo().equals(masMap.getString("DAMDANGJA_ID"))) || loginUser.getAuthCodes().contains("CMM_SYS"))
				){ %>
		<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goMasModify<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
		<% }%>
    <%if("0".equals(masMap.getString("SIM_CHA_NO"))){ %>
    	<script>
			function goMasDelete<%=sol_mas_uid%>() {		
				var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>";
				
				if(confirm(msg)){
					var data = {};
					data["sol_mas_uid"] = "<%=sol_mas_uid%>";
					
					airCommon.callAjax("LMS_SS_MAS", "MAS_DELETE_PROC",data, function(json){
						//$("#listTabsLayer").tabs('close','<%=masMap.getString("GWANRI_NO")%>');
						try{
							try{
								opener.opener.doSearch();	//--리스트 대응
							} catch(e) {
							}
							opener.doSearch();
						}catch(e){
							try{
								opener.opener.initMain(); //--메인화면일때 대응
							}catch(e){
								
							}
						}
						
						window.close();
					});
				}
			}
		</script>
		<%if((!"Y".equals(masMap.getString("STU_ID_YN"))
				&& (loginUser.getUserNo().equals(masMap.getString("DAMDANGJA_ID"))) || loginUser.getAuthCodes().contains("CMM_SYS"))
				){ %>
		<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:goMasDelete<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
		<% }%>
    <%} %>
    </div>
</div>
<%} %>