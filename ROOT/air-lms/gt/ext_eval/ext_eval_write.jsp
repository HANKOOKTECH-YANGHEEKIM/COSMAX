<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="java.net.URLDecoder"%>
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
	String			sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	String			id			=	requestMap.getString("ID");
	String			nam	=	requestMap.getString("NAM");
	
	nam 	= 	URLDecoder.decode(nam, "UTF-8");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults		EXT_EVAL 	= resultMap.getResult("EXT_EVAL");
	
	BeanResultMap masMap = new BeanResultMap();
	if(EXT_EVAL != null && EXT_EVAL.getRowCount()> 0){
		masMap.putAll(EXT_EVAL.getRowResult(0));
	}
	
	String gt_ext_eval_uid	= masMap.getString("GT_EXT_EVAL_UID");
	String temp_gt_ext_eval_uid = StringUtil.getRandomUUID();
	
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String uuid = StringUtil.getRandomUUID();
	
	
	//첨부관련 셋팅
	String att_master_doc_id 				= "";
	String att_default_master_doc_Ids 	= "";
	if(StringUtil.isNotBlank(gt_ext_eval_uid)){
		att_master_doc_id 			= gt_ext_eval_uid;
		att_default_master_doc_Ids 	= gt_ext_eval_uid;
	}else{
		att_master_doc_id 			= temp_gt_ext_eval_uid;
		att_default_master_doc_Ids 	= "";
	}
	
	//-- 코드 정보 문자열 셋팅
	String ext_evalCode = StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMS_PG"), "CODE,LANG_CODE", "");
%>
<form name="saveForm" id="saveForm" method="POST">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>"/>
	<input type="hidden" name="gt_ext_eval_uid" value="<%=gt_ext_eval_uid%>"/>
	<input type="hidden" name="temp_gt_ext_eval_uid" value="<%=temp_gt_ext_eval_uid%>"/>
	<table class="basic">
		<caption><%=StringUtil.getLocaleWord("L.평가", siteLocale)%></caption>
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.대상", siteLocale)%></th>
			<td>
				<%=nam%>
				<input type="hidden" name="byeonhosa_id" id="byeonhosa_id" value="<%=StringUtil.convertForInput(id)%>" />
				<input type="hidden" name="byeonhosa_nam" id="byeonhosa_nam" value="<%=StringUtil.convertForInput(nam)%>" />
			</td>
			<th><%=StringUtil.getLocaleWord("L.평점", siteLocale)%></th>
			<td><%=HtmlUtil.getSelect(request, true, "ext_eval", "ext_eval", ext_evalCode, masMap.getString("EXT_EVAL"), "class=\"select width_max\"")%></td>
		</tr>
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.의견", siteLocale)%></th>
			<td class="td2" colspan="3">
				<textarea class="textarea width_max" rows="5"  name="ext_eval_memo" id="ext_eval_memo" onblur="airCommon.validateMaxLength(this, 4000)" style="height:80px;"><%=StringUtil.convertForInput(masMap.getString("EXT_EVAL_MEMO"))%></textarea>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="doSave();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
	    <span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>	
<script>
var doSave = function(){
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			opener.getLmsGtExtEval<%=sol_mas_uid%>(1);
			window.close();
		});
	}
};
</script>