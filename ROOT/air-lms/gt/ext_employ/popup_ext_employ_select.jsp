<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String callbackFunction		= requestMap.getString("CALLBACKFUNCTION");
	String multipleSelectYn		= requestMap.getString("MULTIPLESELECTYN");
	
	String schGroupName			= requestMap.getString("SCHGROUPNAME");
	String schUserName			= requestMap.getString("SCHUSERNAME");
	String sol_mas_uid			= requestMap.getString("SOL_MAS_UID");
		
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	SQLResults listResult 		= resultMap.getResult("EMPL_LIST");	
	Integer listTotalCount		= 0;
	
	if(listResult != null) {
		 listTotalCount = listResult.getRowCount();
	}
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
%>  
<script type="text/javascript">
	/**
	 * 검색 수행
	 */	
	function doSearch(frm, isCheckEnter) {
		if (isCheckEnter && event.keyCode != 13) {			
			return;
		}
		
		frm.<%=CommonConstants.PAGE_NO%>.value = "1";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();		
	}		
	
	/**
	 * 페이지 이동
	 */	 
	function goPage(frm, pageNo, rowSize) {		
		frm.<%=CommonConstants.PAGE_NO%>.value = pageNo;
		frm.<%=CommonConstants.PAGE_ROWSIZE%>.value = rowSize;
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();		
	}
	
	/**
	 * 사용자 선택 이벤트 처리
	 */
	function doSelect(frm, idx) {		
		var func = getCallbackFunction(frm, idx);
		
		var mode_code = frm.<%=CommonConstants.MODE_CODE%>.value;
		if (mode_code.indexOf("POPUP_") > -1) {
			if (eval("opener."+ func) != false) {
				//-- 콜백함수 실행결과가 false가 아니면 현재 창을 닫음 (※ false일 경우 다시 선택할 수 있게 구현한 것임)
				self.close();
			}
		} else {
			eval("parent."+ func);			
		}
	}
	
	/**
	 * 콜백함수 반환
	 */
	function getCallbackFunction(frm, idx) {
		var res = unescape(frm.callbackFunction.value);
		
		if (res != "") {
			res = res.replace(/\[GT_WIIM_UID\]/g, document.getElementsByName("gt_wiim_uid")[idx].value);
			res = res.replace(/\[GT_MAS_UID\]/g, document.getElementsByName("gt_mas_uid")[idx].value);
			res = res.replace(/\[DOC_MAS_UID\]/g, document.getElementsByName("doc_mas_uid")[idx].value);
			res = res.replace(/\[GT_MAS_GBN\]/g, document.getElementsByName("gt_mas_gbn")[idx].value);
			res = res.replace(/\[GT_WIIM_IN_UID\]/g, document.getElementsByName("gt_wiim_in_uid")[idx].value);
			res = res.replace(/\[BYEONHOSA_ID\]/g, document.getElementsByName("byeonhosa_id")[idx].value);
			res = res.replace(/\[BYEONHOSA_NAM\]/g, airCommon.convertForJavascript(document.getElementsByName("byeonhosa_nam")[idx].value));
			res = res.replace(/\[SOSOG_COD\]/g, document.getElementsByName("sosog_cod")[idx].value);
			res = res.replace(/\[SOSOG_NAM\]/g, airCommon.convertForJavascript(document.getElementsByName("sosog_nam")[idx].value));
		}

		return res;
	}
	
</script>

<form name="form1" method="post">	
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
	<input type="hidden" name="callbackFunction" value="<%=StringUtil.convertForInput(callbackFunction)%>" />
	<input type="hidden" name="multipleSelectYn" value="<%=multipleSelectYn%>" />
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	
	<table class="box">
	<tr>
		<td class="corner_lt"></td><td class="border_mt"></td><td class="corner_rt"></td>
	</tr>
	<tr>
		<td class="border_lm"></td>
		<td class="body">		
			<table>
			<colgroup>
				<col style="width:12%" />
				<col style="width:17%" />
				<col style="width:12%" />
				<col style="width:17%" />
				<col style="width:12%" />
				<col style="width:17%" />
				<col style="width:auto" />
			</colgroup>
				<tr>
					<th><%=StringUtil.getLocaleWord("L.소속",siteLocale)%></th>		
					<td>
						<input type="text" name="schGroupName" value="<%=StringUtil.convertForInput(schGroupName)%>" class="text width_max" onkeydown="doSearch(document.form1, true)" maxlength="30" />
					</td>
					<th><%=StringUtil.getLocaleWord("L.이름",siteLocale)%></th>		
					<td>
						<input type="text" name="schUserName" value="<%=StringUtil.convertForInput(schUserName)%>" class="text width_max" onkeydown="doSearch(document.form1, true)" maxlength="30" />
					</td>
					<td class="hbuttons">
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);" ><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
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
	
	<table class="list_top">
		<tr>
			<td align="left">
				<span class="totalcount">전체 : <span class="info"><%=listTotalCount%></span> 건</span>
			</td>
			<td align="right">	
<% if ("Y".equals(multipleSelectYn)) { %>
				<script>
				function doMultipleSelect(frm) {
					var mode_code = frm.<%=CommonConstants.MODE_CODE%>.value;
					var is_popup = (mode_code.indexOf("POPUP_") > -1 ? true : false);
					var func_res = true;
					
					var obj = document.getElementsByName("chkSelect");
					if (obj != null && obj.length > 0) {
						for (var idx=0; idx<obj.length; idx++) {
							if (obj[idx].checked) {							
								var func = getCallbackFunction(frm, idx);
								
								if (is_popup) {
									// 팝업일
									func_res = eval("opener."+ func);
								} else {
									func_res = eval("parent."+ func);			
								}
							}
						}
					}
					
					if (is_popup && func_res != false) {
						//-- 콜백함수 실행결과가 false가 아니면 현재 창을 닫음 (※ false일 경우 다시 선택할 수 있게 구현한 것임)
						self.close();
					}
				}
				</script>
				<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doMultipleSelect(document.form1)"><%=StringUtil.getLocaleWord("B.CONFIRM",siteLocale)%></a></span>
<% } %>	
			</td>
		</tr>
	</table>
	
	<table class="list">		
		<thead>
			<tr>
				<th width="5%"></th>
				<th width="27%"><%=StringUtil.getLocaleWord("L.이름",siteLocale)%></th>
				<th width="48%"><%=StringUtil.getLocaleWord("L.소속",siteLocale)%></th>
			</tr>
		</thead>
		<tbody>
<%
	if (listResult != null && listResult.getRowCount() > 0) {
		for (int i = 0; i < listResult.getRowCount(); i++) {
			String gt_wiim_uid 			= listResult.getString(i, "GT_WIIM_UID");
			String gt_mas_uid			= listResult.getString(i, "GT_MAS_UID");
			String doc_mas_uid			= listResult.getString(i, "DOC_MAS_UID");
			String gt_mas_gbn         	= listResult.getString(i, "GT_MAS_GBN");
			String gt_wiim_in_uid       = listResult.getString(i, "GT_WIIM_IN_UID");
			String sosog_cod            = listResult.getString(i, "SOSOG_COD");
			String sosog_nam            = listResult.getString(i, "SOSOG_NAM");
			String byeonhosa_id         = listResult.getString(i, "BYEONHOSA_ID");
			String byeonhosa_nam        = listResult.getString(i, "BYEONHOSA_NAM");
			String pgl_yn               = listResult.getString(i, "PGL_YN");
%>
			<tr>
				<td align="center">
<%
			if ("Y".equals(multipleSelectYn)) {
%>
					<input type="checkbox" name="chkSelect" class="checkbox" value="<%=i%>" />
<%							
			} else {
%>				
					<input type="radio" name="rdoSelect" class="radio" value="<%=i%>" onclick="doSelect(document.form1, this.value);" />
<%
			}
%>					
					<input type="hidden" name="gt_wiim_uid" value="<%=gt_wiim_uid%>" />
					<input type="hidden" name="gt_mas_uid" value="<%=gt_mas_uid%>" />
					<input type="hidden" name="doc_mas_uid" value="<%=doc_mas_uid%>" />
					<input type="hidden" name="gt_mas_gbn" value="<%=gt_mas_gbn%>" />
					<input type="hidden" name="gt_wiim_in_uid" value="<%=gt_wiim_in_uid%>" />
					<input type="hidden" name="sosog_cod" value="<%=sosog_cod%>" />
					<input type="hidden" name="sosog_nam" value="<%=StringUtil.convertForInput(sosog_nam)%>" />
					<input type="hidden" name="byeonhosa_id" value="<%=byeonhosa_id%>" />
					<input type="hidden" name="byeonhosa_nam" value="<%=StringUtil.convertForInput(byeonhosa_nam)%>" />
					<input type="hidden" name="pgl_yn" value="<%=pgl_yn%>" />
				</td>				
				<td align="center"><%=byeonhosa_nam%></td>
				<td><%=sosog_nam %></td>				
			</tr>
			<%
		}
	} else {
		%>
		<tr>
			<td align="center" colspan="5"><%=StringUtil.getLocaleWord("M.INFO_NORECORDS",siteLocale)%></td>
		</tr>
		<%
	}
%>
		</tbody>
	</table>
</form>  
