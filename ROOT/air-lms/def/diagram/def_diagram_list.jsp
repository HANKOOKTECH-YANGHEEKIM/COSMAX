<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>

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

	String schMunseoSeosigNo = requestMap.getString("SCHMUNSEOSEOSIGNO");
	String schMunseoSeosigNamko = requestMap.getString("SCHMUNSEOSEOSIGNAMKO");

	String schSysMunseoBunryuGbn01 = requestMap.getString("SCHSYSMUNSEOBUNRYUGBN01");
	String schSysMunseoBunryuGbn02 = requestMap.getString("SCHSYSMUNSEOBUNRYUGBN02");
	String schSysMunseoBunryuGbn03 = requestMap.getString("SCHSYSMUNSEOBUNRYUGBN03");

	String schMunseoSeosigGbn = requestMap.getString("SCHMUNSEOSEOSIGGBN");

	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	
	SQLResults sysMunseoBunryuGbnList = resultMap.getResult("SYS_MUNSEO_BUNRYU_GBN_LIST");
	SQLResults listResult = resultMap.getResult("LIST");
	int listTotalCount = resultMap.getInt("LIST_TOTALCOUNT");
	SQLResults defList = resultMap.getResult("DEF_LIST");
	SQLResults STATUS_GBN = resultMap.getResult("STATUS_GBN");

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	
	String sysMunseoBunryuGbnStr = StringUtil.getCodestrFromSQLResults(sysMunseoBunryuGbnList, "CODE_ID,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
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
	frm.<%=CommonConstants.MODE_CODE%>.value = "<%=modeCode%>";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();
	}

	/**
	 * 신규작성 페이지로 이동
	 */
	function goWrite(frm, munseo_seosig_no,munseo_seosig_nam,parent_code_id,status_gbn) {
		
		airCommon.openWindow("", "1024", "650", "POPUP_DIAGRAM_WRITE", "yes", "yes", "");
		
		frm.status_gbn.value = status_gbn;
		frm.munseo_seosig_no.value = munseo_seosig_no;
		frm.munseo_seosig_nam.value = munseo_seosig_nam;
		frm.parent_code_id.value = parent_code_id;
		frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_FORM";
		frm.action = "/ServletController";
		frm.target = "POPUP_DIAGRAM_WRITE";
		frm.submit();
	}

	/**
	 * 페이지 이동
	 */
	function goPage(frm, pageNo, rowSize, pageOrderByField, pageOrderByMethod) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
		frm.<%=CommonConstants.PAGE_NO%>.value = pageNo;
		frm.<%=CommonConstants.PAGE_ROWSIZE%>.value = rowSize;

		//정렬 조건값이 있으면 셋팅
		if (pageOrderByField != undefined && pageOrderByMethod != undefined) {
			frm.<%=CommonConstants.PAGE_ORDERBY_FIELD%>.value = pageOrderByField;
			frm.<%=CommonConstants.PAGE_ORDERBY_METHOD%>.value = pageOrderByMethod;
		}

		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();
	}

	function getSysMunseoBunryuGbnCode(targetId, val) {
		var selStr = airCommon.getCodeStrFromXML("SYS_CODE_BY_PARENT_CODE_ID","|-- 선택 --", "", val, "N,S", "code_id, name_ko");
		airCommon.initializeSelect(targetId, selStr, "");
	}
	$(function(){
		getSysMunseoBunryuGbnCode('schSysMunseoBunryuGbn02', '<%=schSysMunseoBunryuGbn01%>');
		
		if("<%=schSysMunseoBunryuGbn02%>" != ""){
			var obj = document.getElementById("schSysMunseoBunryuGbn02");
			var index = 0;
			for(var i=0; i<obj.length; i++){
				if(obj[i].value == "<%=schSysMunseoBunryuGbn02%>"){
					index = i;
				}
			}
			
			obj.selectedIndex = index;
		}
		
		
		getSysMunseoBunryuGbnCode('schSysMunseoBunryuGbn03', '<%=schSysMunseoBunryuGbn02%>');
		
		if("<%=schSysMunseoBunryuGbn02%>" != ""){
			var obj = document.getElementById("schSysMunseoBunryuGbn03");
			var index = 0;
			for(var i=0; i<obj.length; i++){
				if(obj[i].value == "<%=schSysMunseoBunryuGbn03%>"){
					index = i;
				}
			}
			
			obj.selectedIndex = index;
		}
	})
</script>

<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>"value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>"value="<%=pageRowSize%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
	<input type="hidden" name="munseo_seosig_no" />
	<input type="hidden" name="munseo_seosig_nam" />
	<input type="hidden" name="parent_code_id" />
	<input type="hidden" name="status_gbn" />

	<table class="box">
	<tr>
		<td class="corner_lt"></td>
		<td class="border_mt"></td>
		<td class="corner_rt"></td>
	</tr>
	<tr>
		<td class="border_lm"></td>
		<td class="body">
			<table>
				<colgroup>
					<col style="width:15%" />
					<col style="width:30%" />
					<col style="width:15%" />
					<col style="width:30%" />
					<col style="width:auto" />
				</colgroup>
				<tr>				
					<th>문서서식번호</th>					
					<td><input type="text" name="schMunseoSeosigNo" value="<%=StringUtil.convertForInput(schMunseoSeosigNo) %>" style="width:90%" maxlength="10" class="text" onkeydown="doSearch(document.form1, true)" /></td>	
					<th>문서서식명 :</th>					
					<td><input type="text" name="schMunseoSeosigNamko" value="<%=StringUtil.convertForInput(schMunseoSeosigNamko) %>" style="width:90%" class="text" onkeydown="doSearch(document.form1, true)" /></td>
					<td rowspan="2" class="verticalContainer">
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
					</td>
				</tr>
				<tr>				
					<th>문서분류구분</th>						
					<td colspan="3">
						솔루션 <%=HtmlUtil.getSelect(request, true, "schSysMunseoBunryuGbn01", "schSysMunseoBunryuGbn01", sysMunseoBunryuGbnStr, schSysMunseoBunryuGbn01, "class=\"select\" onChange=\"getSysMunseoBunryuGbnCode('schSysMunseoBunryuGbn02', this.value);\"") %>
						업무유형 <%=HtmlUtil.getSelect(request, true, "schSysMunseoBunryuGbn02", "schSysMunseoBunryuGbn02", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale), schSysMunseoBunryuGbn02, "class=\"select\" onChange=\"getSysMunseoBunryuGbnCode('schSysMunseoBunryuGbn03', this.value);\"") %>
						단계 <%=HtmlUtil.getSelect(request, true, "schSysMunseoBunryuGbn03", "schSysMunseoBunryuGbn03", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale), schSysMunseoBunryuGbn03, "class=\"select\"") %>
					</td>
				</tr>	
		</table>
	</td>
		<td class="border_rm"></td>
	</tr>
	<tr>
		<td class="corner_lb"></td>
		<td class="border_mb"></td>
		<td class="corner_rb"></td>
	</tr>							
	</table>
	
	<table class="list_select" style="margin-top:5px;">
		<thead>
			<tr>
				<th style="width:7%">번호</th>
				<th style="width:15%">문서번호</th>
				<th style="width:15%">문서명</th>
				<th style="width:auto">상태 이벤트</th>
		</thead>
		<tbody>
			<%
				int sameCodeIdCnt = 1;
				int sameCodeIdNum = 0;
				if (listResult != null && listResult.getRowCount() > 0) {
					for (int i = 0; i < listResult.getRowCount(); i++) {
						int row_no = i+1;
						
						String def_doc_main_uid			= listResult.getString(i, "def_doc_main_uid");
						String munseo_ord_seq			= listResult.getString(i, "munseo_ord_seq");
						String munseo_seosig_no			= listResult.getString(i, "munseo_seosig_no");
						String munseo_bunryu_gbn_nam1	= listResult.getString(i, "munseo_bunryu_gbn_nam1");
						String munseo_bunryu_gbn_nam2	= listResult.getString(i, "munseo_bunryu_gbn_nam2");
						String munseo_bunryu_gbn_nam3	= listResult.getString(i, "munseo_bunryu_gbn_nam3");
						String munseo_seosig_nam_ko		= listResult.getString(i, "munseo_seosig_nam_ko");
						String munseo_bunryu_gbn_cod2	= listResult.getString(i, "MUNSEO_BUNRYU_GBN_COD2");
						
						String parent_code_id = "LMS_"+munseo_bunryu_gbn_cod2+"_DIAGRAM";
						
						
			%>
			<tr onClick="javascript:goWrite(document.form1,'<%=munseo_seosig_no%>','<%=munseo_seosig_nam_ko %>','<%=parent_code_id%>','<%=munseo_bunryu_gbn_cod2%>')" style="cursor:pointer;">
				<td align="center"><%=row_no%></td>
				<td align="center"><%=munseo_seosig_no%></td>
				<td align="center"><%=munseo_seosig_nam_ko %></td>
				<td style="text-align:left;">
					<% if(listResult != null && listResult.getRowCount() > 0){ %>
					<table class="inner">
						<tbody>
					<% 		for(int j=0; j< defList.getRowCount(); j++){ %>
							<%if(munseo_seosig_no.equals(defList.getString(j, "MUNSEO_SEOSIG_NO"))){ %>
							<tr >
								<th style="width:33%"><%=StringUtil.getCodestrValue(request,defList.getString(j, "flow_gbn"), CommonConstants.CHEORI_TYPE_STR2) %></th>
								<td ><%=defList.getString(j, "STATUS_CODE_NAM") %></td>
							</tr>
							<%} %>
					<% 		} %>
						</tbody>
					</table>
					<% } %>
				</td>
			</tr>
			<%
				}
				} else {
			%>
			<tr>
				<td align="center" colspan="8"><%=StringUtil.getLocaleWord("M.INFO_NORECORDS", siteLocale)%></td>
			</tr>
			<%
				}
			%>
		</tbody>
	</table>

	<%-- 페이지 목록 --%>
	<%=HtmlUtil.getPageList(listTotalCount,Integer.parseInt(pageNo), Integer.parseInt(pageRowSize),"goPage(document.form1, [PAGE_NO], [ROW_SIZE])")%>
</form>