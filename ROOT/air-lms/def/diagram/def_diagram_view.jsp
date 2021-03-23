<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= requestMap.getString(CommonConstants.PAGE_NO);

	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults viewResult 		= resultMap.getResult("VIEW");
	SQLResults defDocPatiSangdanList	= resultMap.getResult("DEF_DOC_PATI_SANGDAN_LIST");
	SQLResults defDocPatiHadanList		= resultMap.getResult("DEF_DOC_PATI_HADAN_LIST");
	SQLResults defDocPatiGeomList		= resultMap.getResult("DEF_DOC_PATI_GEOM_LIST");
	SQLResults defDocPatiGyeolList		= resultMap.getResult("DEF_DOC_PATI_GYEOL_LIST");
	SQLResults defDocPatiSuList			= resultMap.getResult("DEF_DOC_PATI_SU_LIST");
	SQLResults sysMunseoBunryuGbnList	= resultMap.getResult("SYS_MUNSEO_BUNRYU_GBN_LIST"); 
	SQLResults userAuthListResult 		= resultMap.getResult("USER_AUTH_LIST");
	
	
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode		= resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 상세보기 값 셋팅
	String def_doc_main_uid                 = viewResult.getString(0,"def_doc_main_uid");
	String munseo_seosig_no                 = viewResult.getString(0,"munseo_seosig_no");
	String munseo_bunryu_gbn_sys_cod_id1    = viewResult.getString(0,"munseo_bunryu_gbn_sys_cod_id1");
	String munseo_bunryu_gbn_cod1           = viewResult.getString(0,"munseo_bunryu_gbn_cod1");
	String munseo_bunryu_gbn_nam1           = viewResult.getString(0,"munseo_bunryu_gbn_nam1");
	String munseo_bunryu_gbn_sys_cod_id2    = viewResult.getString(0,"munseo_bunryu_gbn_sys_cod_id2");
	String munseo_bunryu_gbn_cod2           = viewResult.getString(0,"munseo_bunryu_gbn_cod2");
	String munseo_bunryu_gbn_nam2           = viewResult.getString(0,"munseo_bunryu_gbn_nam2");
	String munseo_bunryu_gbn_sys_cod_id3    = viewResult.getString(0,"munseo_bunryu_gbn_sys_cod_id3");
	String munseo_bunryu_gbn_cod3           = viewResult.getString(0,"munseo_bunryu_gbn_cod3");
	String munseo_bunryu_gbn_nam3           = viewResult.getString(0,"munseo_bunryu_gbn_nam3");
	String munseo_seosig_gbn                = viewResult.getString(0,"munseo_seosig_gbn");
	String munseo_seosig_gbn_nam            = viewResult.getString(0,"munseo_seosig_gbn_nam");
	String munseo_desc               		= viewResult.getString(0,"munseo_desc");
	String pati_jonjae_yn                   = viewResult.getString(0,"pati_jonjae_yn");
	String munseo_seosig_nam_ko             = viewResult.getString(0,"munseo_seosig_nam_ko");
	String munseo_seosig_nam_en             = viewResult.getString(0,"munseo_seosig_nam_en");
	String gibon_tit                        = viewResult.getString(0,"gibon_tit");
	String gibon_memo                       = viewResult.getString(0,"gibon_memo");
	String gibon_tit_dsp_yn                 = viewResult.getString(0,"gibon_tit_dsp_yn");
	String gibon_memo_dsp_yn                = viewResult.getString(0,"gibon_memo_dsp_yn");
	String gibon_file_dsp_yn                = viewResult.getString(0,"gibon_file_dsp_yn");
	String sayong_yn                        = viewResult.getString(0,"sayong_yn");
	String munseo_ord_seq                   = viewResult.getString(0,"munseo_ord_seq");
	String munseo_saengseong_auth			= viewResult.getString(0,"munseo_saengseong_auth");
	String munseo_end_edit_yn               = viewResult.getString(0,"munseo_end_edit_yn");
	String munseo_create_gbn                = viewResult.getString(0,"munseo_create_gbn");
	String su_ok_able_yn					= viewResult.getString(0,"su_ok_able_yn");
	String pyegi_able_yn					= viewResult.getString(0,"pyegi_able_yn");
	String doc_sagje_able_yn				= viewResult.getString(0,"doc_sagje_able_yn");
	String doc_real_sagje_able_yn			= viewResult.getString(0,"doc_real_sagje_able_yn");
	String sangtae_munseo_yn				= viewResult.getString(0,"sangtae_munseo_yn");
	
	String pati_sangdan_jonjae_yn			= "N";
	String pati_hadan_jonjae_yn				= "N";
	String pati_geom_jonjae_yn				= "N";
	String pati_gyeol_jonjae_yn				= "N";
	String pati_su_jonjae_yn				= "N";
	
	
	if(defDocPatiSangdanList != null && defDocPatiSangdanList.getRowCount() > 0){
		pati_sangdan_jonjae_yn = "Y";
	}
	
	if(defDocPatiHadanList != null && defDocPatiHadanList.getRowCount() > 0){
		pati_hadan_jonjae_yn = "Y";
	}
	
	if(defDocPatiGeomList != null && defDocPatiGeomList.getRowCount() > 0){
		pati_geom_jonjae_yn = "Y";
	}
	
	if(defDocPatiGyeolList != null && defDocPatiGyeolList.getRowCount() > 0){
		pati_gyeol_jonjae_yn = "Y";
	}
	
	if(defDocPatiSuList != null && defDocPatiSuList.getRowCount() > 0){
		pati_su_jonjae_yn = "Y";
	}


	
	//-- 코드정보 문자열 셋팅
	String sysMunseoBunryuGbnStr = StringUtil.getCodestrFromSQLResults(sysMunseoBunryuGbnList, "CODE_ID,LANG_CODE", "|--선택--" );
	String userAuthCodestr 	= StringUtil.getCodestrFromSQLResults(userAuthListResult, "CODE,LANG_CODE", "");
	
	//-- 문서생성권한 선택
	boolean IsInput 	= false;
	String FormName		= "munseo_saengseong_auth"; 
	String CodeStr		= userAuthCodestr;
	String InitData		= munseo_saengseong_auth;	
	String out_Html		= "";
	
	StringBuffer res = new StringBuffer();
	
	String a_code[], a_init[], a_temp[];
	String v_title 		= "";
	String v_checked 	= "";
	String v_disabled 	= "";
	
	// 입력 뷰가 아닐 경우 읽기전용으로 출력
	if (!IsInput)
	{
		FormName += "__ReadOnly";
		v_disabled = " disabled";
	}
	
	// 구분자 기본값 셋팅
	String Separ1 = "|";
	String Separ2 = "^";
	String Separ3 = ",";

	a_code = StringUtils.splitByWholeSeparatorPreserveAllTokens(CodeStr, Separ2);
	a_init = StringUtils.splitByWholeSeparatorPreserveAllTokens(InitData, Separ3);

	if (a_code != null)
	{
		int colspan_size	= (4 - (a_code.length%4)) * 2;
		
		for (int i = 0; i < a_code.length; i++) {
	a_temp = StringUtils.splitByWholeSeparatorPreserveAllTokens(a_code[i], Separ1);
	
	//-- 툴팁 처리				
	if (a_temp.length > 2) {
		v_title = " title=\""+ StringEscapeUtils.escapeHtml4(a_temp[2]) +"\"";
	} else {
		v_title = " title=\""+ StringEscapeUtils.escapeHtml4(a_temp[1]) +"\"";
	}
	
	//-- 선택항목 처리
	v_checked = "";
	if (a_init != null)
	{
		for (int j = 0; j < a_init.length; j++) {
	if (a_temp[0].equals(a_init[j].trim())) {
		v_checked = " checked";
		break;
	}
		}
	}
	
	if (i%4 == 0) res.append( "</tr><tr>" );
	res.append( "<th ><input type=\"checkbox\" name=\""+ FormName +"\" id=\""+ FormName + i +"\" value=\""+ StringEscapeUtils.escapeHtml4(a_temp[0]) +"\" style=\"cursor:pointer;\" "+ v_title + v_checked + v_disabled +" /></td>" );
	res.append( "<td>" );
	res.append( "	<label for=\""+ FormName + i +"\""+ v_title +" style=\"cursor:pointer;\" >"+ a_temp[1] +"</label>" );
	res.append( "</td>" );			
		}
		res.append( "	 <td colspan=\""+ colspan_size +"\"></td>" );
		res.append( "</tr>" );		
	}
	
	out_Html = res.toString();
%>

<script type="text/javascript">
/**
 * 목록 페이지로 이동
 */	
function goList(frm) {		
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_GOLIST",siteLocale)%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();	
	}	
}

/**
 * 수정등록 페이지로 이동
 */
function goModify(frm) {
	frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_FORM";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();
}

function goDocumentPreview(frm){
	window.open('/ServletController?<%=CommonConstants.ACTION_CODE%>=SYS_DEF_DOC_MAIN&<%=CommonConstants.MODE_CODE%>=WRITE_PREVIEW&def_doc_main_uid=<%=def_doc_main_uid%>','view_test','width=1024,height=700,left=50,top=20,status=0,scrollbars=yes');
}


</script>

<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode %>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="def_doc_main_uid" value="<%=def_doc_main_uid%>" />
	
	
	

<table class="basic">
	<caption>기본정보</caption>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.문서서식번호",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2" colspan="3"><%=munseo_seosig_no%></td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.문서분류구분",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2" colspan="3">
				<b>[솔루션] :</b> <%=StringUtil.convertFor(munseo_bunryu_gbn_nam1, "VIEW") %> 
				<b>[업무유형] :</b> <%=StringUtil.convertFor(munseo_bunryu_gbn_nam2, "VIEW") %> 
				<b>[단계] :</b> <%=StringUtil.convertFor(munseo_bunryu_gbn_nam3, "VIEW") %>
		</td>		
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식구분",siteLocale)%></th>						
		<td class="td4">
			<%=StringUtil.convertFor(munseo_seosig_gbn_nam, "VIEW") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식사용유무",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getInputRadio(request, false, "sayong_yn", "Y|사용^N|미사용", sayong_yn, "", "")%>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.제목표시유무",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, false, "gibon_tit_dsp_yn", "gibon_tit_dsp_yn", "|--선택--^Y|표시^N|미표시", gibon_tit_dsp_yn, "onChange=\"doGibonTitDspYn(this.value);\"") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.내용표시유무",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, false, "gibon_memo_dsp_yn", "gibon_memo_dsp_yn", "|--선택--^Y|표시^N|미표시", gibon_memo_dsp_yn, "onChange=\"doGibonMemoDspYn(this.value);\"") %>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부파일표시유무",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, false, "gibon_file_dsp_yn", "gibon_file_dsp_yn", "|--선택--^Y|표시^N|미표시", gibon_file_dsp_yn, "onChange=\"doGibonFileDspYn(this.value);\"") %>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서종료후_수정가능",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, false, "munseo_end_edit_yn", "munseo_end_edit_yn", "|--선택--^Y|가능^N|불가", munseo_end_edit_yn, "") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서생성구분",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, false, "munseo_create_gbn", "munseo_create_gbn", "|--선택--^HEAD|시작문서^TAIL|파생문서", munseo_create_gbn, "") %>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.수신시_수신확인가능유무",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, false, "su_ok_able_yn", "su_ok_able_yn", "|--선택--^Y|가능^N|불가", su_ok_able_yn, "") %>
			※다음진행가능 문서가 있을 때, 진행하지않고 수신확인으로 문서 종결처리가능한지의 여부
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서폐기가능",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, false, "pyegi_able_yn", "pyegi_able_yn", "|--선택--^Y|가능^N|불가", pyegi_able_yn, "") %>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서삭제가능",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, false, "doc_sagje_able_yn", "doc_sagje_able_yn", "|--선택--^Y|가능^N|불가", doc_sagje_able_yn, "") %>
		</td>
	</tr>	
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서물리적삭제가능",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, false, "doc_real_sagje_able_yn", "doc_real_sagje_able_yn", "|--선택--^Y|가능^N|불가", doc_real_sagje_able_yn, "") %>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.상태관련문서여부",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, false, "sangtae_munseo_yn", "sangtae_munseo_yn", "|--선택--^Y|관련^N|미관련", sangtae_munseo_yn, "") %>
			※업무단에서 최종진행상태(최종으로 진행한 문서)를 구해야 할 경우, 상태관련 문서여부가 Y인건만 구할수 있도록 하기 위한 구분값
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서설명",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<%=StringUtil.convertFor(munseo_desc, "VIEW")%>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서생성권한",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<table class="basic">
				<colgroup>
					<col style="width:40px" />
					<col style="width:100px" />
					<col style="width:40px" />
					<col style="width:100px" />
					<col style="width:40px" />
					<col style="width:100px" />
					<col style="width:40px" />
					<col style="width:100px" />
				</colgroup>
				<%=out_Html%>			
			</table>
		</td>
	</tr>
</table>
<br>
<br>
<br>

<table class="basic">
	<caption>구성정보</caption>	
</table>

<table class="box" >
	<tr>
		<td align="center"><%=StringUtil.getLocaleWord("L.문서서식명_한글",siteLocale)%> :  <%=StringUtil.convertFor(munseo_seosig_nam_ko,"VIEW") %></td>		
	</tr>
	<tr>
		<td align="center"><%=StringUtil.getLocaleWord("L.문서서식명_영문",siteLocale)%> :  <%=StringUtil.convertFor(munseo_seosig_nam_en,"VIEW") %></td>		
	</tr>
</table>
<p>

<table class="basic">
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.상단파티클_존재유무",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2">
			<%=HtmlUtil.getInputRadio(request, false, "pati_sangdan_jonjae_yn", "Y|있음^N|없음", pati_sangdan_jonjae_yn, "onClick=\"chgPatiSangdanJonjaeYn(this.value);\"", "")%>
			
		</td>		
	</tr>	
</table>

<table id="particleSangdanTable" class="basic" style="display:<%if("Y".equals(pati_sangdan_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
<%if(defDocPatiSangdanList != null && defDocPatiSangdanList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiSangdanList.getRowCount(); i++){%>
	<tr>
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th>			
					<td class="td4"><%=StringUtil.convertFor(defDocPatiSangdanList.getString(i, "pati_gwanri_no"),"VIEW") %></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_sangdan" value="<%=(StringUtil.convertForInput(defDocPatiSangdanList.getString(i, "pati_gbn_nam1"))+" / "+StringUtil.convertForInput(defDocPatiSangdanList.getString(i, "pati_gbn_nam2")))%>" class="text width_max" style="border:0px" readonly/> </td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<%=StringUtil.convertFor(defDocPatiSangdanList.getString(i, "pati_nam"),"VIEW") %>						
					</td>
				</tr>
			</table>						
		</td>
	</tr>	
	<%}%>
<%}%>	
</table>

<table class="basic">
	<tr id="tr_gibon_tit" style="display:<%if("Y".equals(gibon_tit_dsp_yn)){%>visible<%}else{%>none<%}%>;">
		<th class="th2"><%=StringUtil.getLocaleWord("L.기본제목",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2"><%=StringUtil.convertFor(gibon_tit,"VIEW") %></td>		
	</tr>
	<tr id="tr_gibon_memo" style="display:<%if("Y".equals(gibon_memo_dsp_yn)){%>visible<%}else{%>none<%}%>;">
		<th class="th2"><%=StringUtil.getLocaleWord("L.기본내용",siteLocale)%></th>
		<td class="td2"><%=StringUtil.convertFor(gibon_memo,"EDITOR")%></td>	
	</tr>
	<tr>
		<th class="th2">첨부</th>
		<td class="td2"><font color="#AAAAAA">첨부영역</font></td>	
	</tr>
</table>

<table class="basic">
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.하단파티클_존재유무",siteLocale)%></th><%-- onblur="airCommon.validateNumber(this, this.value)" --%>
		<td class="td2">
			<%=HtmlUtil.getInputRadio(request, false, "pati_hadan_jonjae_yn", "Y|있음^N|없음", pati_hadan_jonjae_yn, "onClick=\"chgPatiHadanJonjaeYn(this.value);\"", "")%>
		</td>		
	</tr>	
</table>

<table id="particleHadanTable" class="basic" style="display:<%if("Y".equals(pati_hadan_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
<%if(defDocPatiHadanList != null && defDocPatiHadanList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiHadanList.getRowCount(); i++){%>
	<tr>
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th>			
					<td class="td4"><%=StringUtil.convertFor(defDocPatiHadanList.getString(i, "pati_gwanri_no"),"VIEW") %></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_hadan" value="<%=(StringUtil.convertForInput(defDocPatiHadanList.getString(i, "pati_gbn_nam1"))+" / "+StringUtil.convertForInput(defDocPatiHadanList.getString(i, "pati_gbn_nam2")))%>" class="text width_max" style="border:0px" readonly/> </td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<%=StringUtil.convertFor(defDocPatiHadanList.getString(i, "pati_nam"),"VIEW") %>						
					</td>
				</tr>
			</table>						
		</td>
	</tr>	
	<%}%>
<%}%>	
</table>
<p>

<table class="basic">
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.검토파티클_존재유무",siteLocale)%></th><%-- onblur="airCommon.validateNumber(this, this.value)" --%>
		<td class="td2"><%=HtmlUtil.getInputRadio(request, false, "pati_geom_jonjae_yn", "Y|있음^N|없음", pati_geom_jonjae_yn, "onClick=\"chgPatiGeomJonjaeYn(this.value);\"", "")%></td>		
	</tr>	
</table>
<table id="particleGeomTable" class="basic" style="display:<%if("Y".equals(pati_geom_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
<%if(defDocPatiGeomList != null && defDocPatiGeomList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiGeomList.getRowCount(); i++){%>
	<tr>
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th>			
					<td class="td4"><%=StringUtil.convertForInput(defDocPatiGeomList.getString(i, "pati_gwanri_no")) %></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><%=(StringUtil.convertForInput(defDocPatiGeomList.getString(i, "pati_gbn_nam1"))+" / "+StringUtil.convertForInput(defDocPatiGeomList.getString(i, "pati_gbn_nam2")))%></td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<%=StringUtil.convertForInput(defDocPatiGeomList.getString(i, "pati_nam")) %>
					</td>
				</tr>
			</table>						
		</td>
	</tr>	
	<%}%>
<%}%>	
</table>

<p>

<table class="basic">
	<tr>	
		<th class="th2"><%=StringUtil.getLocaleWord("L.결재파티클_존재유무",siteLocale)%></th><%-- onblur="airCommon.validateNumber(this, this.value)" --%>
		<td class="td2">
			<%=HtmlUtil.getInputRadio(request, false, "pati_gyeol_jonjae_yn", "Y|있음^N|없음", pati_gyeol_jonjae_yn, "onClick=\"chgPatiGyeolJonjaeYn(this.value);\"", "")%>
		</td>		
	</tr>	
</table>
<table id="particleGyeolTable" class="basic" style="display:<%if("Y".equals(pati_gyeol_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
<%if(defDocPatiGyeolList != null && defDocPatiGyeolList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiGyeolList.getRowCount(); i++){%>
	<tr>
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th>			
					<td class="td4"><%=StringUtil.convertForInput(defDocPatiGyeolList.getString(i, "pati_gwanri_no")) %></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><%=(StringUtil.convertForInput(defDocPatiGyeolList.getString(i, "pati_gbn_nam1"))+" / "+StringUtil.convertForInput(defDocPatiGyeolList.getString(i, "pati_gbn_nam2")))%></td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<%=StringUtil.convertForInput(defDocPatiGyeolList.getString(i, "pati_nam")) %>
						
					</td>
				</tr>
			</table>						
		</td>
	</tr>	
	<%}%>
<%}%>	
</table>

<p>

<table class="basic">
	<tr>	
		<th class="th2"><%=StringUtil.getLocaleWord("L.수신파티클_존재유무",siteLocale)%></th><%-- onblur="airCommon.validateNumber(this, this.value)" --%>
		<td class="td2">
			<%=HtmlUtil.getInputRadio(request, false, "pati_su_jonjae_yn", "Y|있음^N|없음", pati_su_jonjae_yn, "onClick=\"chgPatiSuJonjaeYn(this.value);\"", "")%>
		</td>		
	</tr>	
</table>
<table id="particleSuTable" class="basic" style="display:<%if("Y".equals(pati_su_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
<%if(defDocPatiSuList != null && defDocPatiSuList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiSuList.getRowCount(); i++){%>
	<tr>
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th>			
					<td class="td4"><%=StringUtil.convertForInput(defDocPatiSuList.getString(i, "pati_gwanri_no")) %></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><%=(StringUtil.convertForInput(defDocPatiSuList.getString(i, "pati_gbn_nam1"))+" / "+StringUtil.convertForInput(defDocPatiSuList.getString(i, "pati_gbn_nam2")))%></td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<%=StringUtil.convertForInput(defDocPatiSuList.getString(i, "pati_nam")) %>
						
					</td>
				</tr>
			</table>						
		</td>
	</tr>	
	<%}%>
<%}%>	
</table>

<p>


	<div class="buttonlist">
		<div class="right">
			<input type="button" name="btnPreview" value="<%=StringUtil.getLocaleWord("B.미리보기",siteLocale)%>" class="btn70" onclick="goDocumentPreview(this.form)" />
			
			<input type="button" name="btnModify" value="<%=StringUtil.getLocaleWord("B.수정",siteLocale)%>" class="btn70" onclick="goModify(this.form)" />		
			<input type="button" name="btnList" value="<%=StringUtil.getLocaleWord("B.목록",siteLocale)%>" class="btn70" onclick="goList(this.form)" />
		</div>
	</div>  

</form>