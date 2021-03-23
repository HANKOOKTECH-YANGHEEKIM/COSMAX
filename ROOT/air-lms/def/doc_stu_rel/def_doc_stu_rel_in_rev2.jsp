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

	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	SQLResults LMS_GBN 	= resultMap.getResult("LMS_GBN");
	SQLResults AUTH_CODES = resultMap.getResult("AUTH_CODES");

	SQLResults IN_LIST = resultMap.getResult("IN_LIST");
	SQLResults OUT_LIST = resultMap.getResult("OUT_LIST");
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String schLmsGbnStr = StringUtil.getCodestrFromSQLResults(LMS_GBN, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String lmsGbnStr = StringUtil.getCodestrFromSQLResults(LMS_GBN, "CODE_ID,LANG_CODE", "");
	String schAuthStr = StringUtil.getCodestrFromSQLResults(AUTH_CODES, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String userAuthStr = StringUtil.getCodestrFromSQLResults(AUTH_CODES, "CODE,LANG_CODE", "");
	
	StringBuffer selData = new StringBuffer();
	
	if(AUTH_CODES != null && AUTH_CODES.getRowCount() > 0){
		for(int i=0; i <  AUTH_CODES.getRowCount(); i++){
			if(i > 0)selData.append("\n,");
			
			selData.append("{\"label\":\"").append(AUTH_CODES.getString(i, "NAME_KO")).append("\", \"value\":\"").append(AUTH_CODES.getString(i, "CODE")).append("\"}");
			
		}
	}
	
	
	//-- 그리드 Url
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_IN_LIST";
%>
<script type="text/javascript">
var outJsonData;
 /**
  * 검색 수행
  */ 
function doSearch(isCheckEnter) {
	 getInList(isCheckEnter);
}
 
var initOutList = function(){
	var data = {}; //airCommon.getSearchQueryParams("nextSearch");
	
	airCommon.callAjax("<%=actionCode%>", "JSON_OUT_LIST",data, function(json){
		outJsonData = json.rows;
	});
};

var getOutList = function(uuid){
	$("#outListBody_"+uuid).html("");
	$(outJsonData).each(function(i, d){
		if(d.IN_UUID == uuid){
			$("#outListTmpl").tmpl(d).appendTo($("#outListBody_"+uuid));
		}
	});
};

//--  리스트
var getInList = function(isCheckEnter){
	
	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
	var data = airCommon.getSearchQueryParams();
	  
	airCommon.callAjax("<%=actionCode%>", "JSON_IN_LIST",data, function(json){
		$("#inListBody").html("");
		$("#inListTmpl").tmpl(json.rows).appendTo($("#inListBody"));
		$(json.rows).each(function(i, d){
			addCompleteStu('add_'+d.UUID);
			getOutList(d.UUID);
		});
	});
};

//--- 상태 추가 처리 및 저장 처리 
var goAddStu = function(isCheckEnter){
	if (isCheckEnter && event.keyCode != 13) {         
         return;
     }
	if ("" == $("#form_no").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"폼 ID")%>");
		$("#form_no").focus();
	    return false;	
	}
	if ($("input:radio[name='auth_cd']:checked").length == 0 ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,"권한자")%>");
		$("input:radio[name='auth_cd']").eq(0).focus();
	    return false;	
	}
	if ("" == $("#stu_id").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"현재상태")%>");
		$("#stu_id").eq(0).focus();
	    return false;	
	}
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.ADD")%>";
	if(confirm(msg)){
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_IN_PROC",data, function(json){
			getInList();
		});
	}
};

var imsiVal = {};	//-- 임시 값 수정
var setImsiVal = function(key, val){
	imsiVal[key] = val;
};

//-- 순번 수정
var goModStr = function(isCheckEnter,orgData, uuid, obj, mode_code){
	
	var col = $(obj).attr("id");
	
	//-- 실패시 원본으로 돌리기 위한 임시 저장 값
	setImsiVal(col, orgData);
	
 	if (isCheckEnter && event.keyCode != 13) {         
         return;
    }
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.MODIFY")%>";
	if(confirm(msg)){
		var data = {};
		data["UUID"] =uuid;
		data[col] =$(obj).val();
		airCommon.callAjax("<%=actionCode%>", mode_code ,data, function(json){
			if(mode_code == "WRITE_OUT_PROC"){
				initOutList();
			}
			getInList();
		});
	}else{
		$(obj).val(imsiVal[col]);
		imsiVal[col] = "";
	}
};

//-- Sel 수정
var goModSel = function(orgData, uuid, obj, mode_code){

	var col = $(obj).attr("id");
	
	setImsiVal(col, orgData);
	
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.MODIFY")%>";
	if(confirm(msg)){
		var data = {};
		data["UUID"] =uuid;
		data[col] =$(obj).val();
		airCommon.callAjax("<%=actionCode%>", mode_code, data, function(json){
			if(mode_code == "WRITE_OUT_PROC"){
				initOutList();
			}
			getInList();
		});
	}else{
		$(obj).val(imsiVal[col]);
		imsiVal[col] = "";
	}
};

var goInRowDelete = function(uuid){
	var msg = "<%=StringUtil.getLocaleMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>";
	if(confirm(msg)){
		airCommon.callAjax("<%=actionCode%>", "DELETE_IN_PROC",{"UUID":uuid}, function(json){
			initOutList();
			getInList();
		});
	}
};
var goOutRowDelete = function(in_uuid, uuid){
	var msg = "<%=StringUtil.getLocaleMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>";
	if(confirm(msg)){
		airCommon.callAjax("<%=actionCode%>", "DELETE_OUT_PROC",{"UUID":uuid}, function(json){
			initOutList();
			getOutList(in_uuid);
		});
	}
};

//--- OUT 대상 상태 추가
var goAddOut = function(in_uuid){
	
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.ADD")%>";
	if(confirm(msg)){
		var data = $("#in_"+in_uuid).serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_OUT_PROC",data, function(json){
			initOutList();
			getOutList(in_uuid);
		});
	}
};

var addCompleteStu = function(id){
	$("#"+id).autocomplete({
		minLength:2,
		matchContains: false,
		source:function(request, response){
			var data = {"SCHWORD":$("#"+id).val()};
			airCommon.callAjax("LMS_DEF_STU", "JSON_LIST",data, function(json){
				 response( jQuery.map( json.rows, function( item ) {
		              return {
		                //id: item.id,
		            	   value: item.STU_ID,
			                label: "["+item.STU_GBN+"]"+"["+item.STU_ID+"]"+item.STU_BASE_NM,
			                stu_id:item.STU_ID
		              }
		          }));
				
			});
		}
	});
};
</script>
<script id="outListTmpl" type="text/html">
	<tr>
		<td style="width:8%">
			<input type="text" class="text" style="width:80%" id="ORD_SEQ" onKeyUp="goModStr(true,'\${ORD_SEQ}','\${UUID}',this,'WRITE_OUT_PROC')" value="\${ORD_SEQ}">
		</td>
		<td style="width:22%">
			<input type="text" class="text width_max" value="\${NEXT_STU_ID}" id="NEXT_STU_ID" onKeyUp="goModStr(true,'\${NEXT_STU_ID}','\${UUID}',this,'WRITE_OUT_PROC')" >
		</td>
		<td style="width:*"><span class="ui_btn medium icon"><span class="confirm"></span><a>\${STU_NM}</a></span></td>
		<td style="width:22%"><input type="text" class="text width_max" value="\${NEXT_FORM_NO}" id="NEXT_FORM_NO" onKeyUp="goModStr(true,'\${NEXT_FORM_NO}','\${UUID}',this,'WRITE_OUT_PROC')" ></td>
		<td style="width:5%"><span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goOutRowDelete('\${IN_UUID}','\${UUID}')"></a></span></td>
	</tr>
</script>
<script id="inListTmpl" type="text/html">
	<tr>
		<td style="text-align:center"><input type="text" class="text" style="width:80%" id="ORD_SEQ" onKeyUp="goModStr(true,'\${ORD_SEQ}','\${UUID}',this,'WRITE_IN_PROC')" value="\${ORD_SEQ}"></td>
		<td style="text-align:center">\${STU_GBN_NM}</td>
		<td style="text-align:center"><input type="text" class="text width_max" value="\${STU_ID}" id="STU_ID" onKeyUp="goModStr(true,'\${STU_ID}','\${UUID}',this,'WRITE_IN_PROC')" ><br/>\${STU_NM}</td>
		<td style="text-align:center"><input type="text" class="text width_max" value="\${FORM_NO}" id="FORM_NO" onKeyUp="goModStr(true,'\${FORM_NO}','\${UUID}',this,'WRITE_IN_PROC')" ></td>
		<td style="text-align:center">
			<select data-type="search" style="width:100%;" id="AUTH_CD" onChange="goModSel('\${AUTH_CD}','\${UUID}',this,'WRITE_IN_PROC')">
				<option value="">--전체--</option>
				<option value="LMS_OFI" {{if AUTH_CD == 'LMS_OFI' }}selected="selected"{{/if}}>법무 임원</option>
				<option value="LMS_BCD" {{if AUTH_CD == 'LMS_BCD' }}selected="selected"{{/if}}>법무 배당</option>
				<option value="LMS_BJD" {{if AUTH_CD == 'LMS_BJD' }}selected="selected"{{/if}}>법무 담당</option>
				<option value="LMS_SYS" {{if AUTH_CD == 'LMS_SYS' }}selected="selected"{{/if}}>법무/시스템 관리자</option>
				<option value="CMM_SYS" {{if AUTH_CD == 'CMM_SYS' }}selected="selected"{{/if}}>공통/시스템 관리자</option>
				<option value="CMM_ISJ" {{if AUTH_CD == 'CMM_ISJ' }}selected="selected"{{/if}}>일반 사용자</option>
				<option value="CMM/BBS" {{if AUTH_CD == 'CMM/BBS' }}selected="selected"{{/if}}>공통/게시판 관리자</option>
				<option value="LMS_CMD" {{if AUTH_CD == 'LMS_CMD' }}selected="selected"{{/if}}>법인인감 담당자</option>
			</select>
		</td>
		<td>
			<form id="in_\${UUID}" onSubmit="return false;">
				<input type="text" class="text" style="width:75%" id="add_\${UUID}" onKeyUp="(event.keyCode == 13)?goAddOut('\${UUID}'):''" name="next_stu_id" placeholder="상태코드 또는 상태 명 검색">
				<input type="hidden" name="in_uuid" value="\${UUID}">
			</form>
			<span class="ui_btn medium icon"><span class="add"></span><a href="javascript:void(0)" onclick="goAddOut('\${UUID}')"><%=StringUtil.getLocaleWord("B.ADD",siteLocale)%></a></span>
			<table class="inner">
				<tbody id="outListBody_\${UUID}">
				</tbody>
			</table>
		</td>
		<td><span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goInRowDelete('\${UUID}')">삭제</a></span></td>
	</tr>
</script>
<script type="text/javascript" src="/common/_lib/jquery-ui/jquery-ui.js"></script>
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>"value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
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
<form name="form1" method="post">
			<table>
				<colgroup>
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:auto" />
				</colgroup>
				<tr>				
					<th>법무구분</th>						
					<td >
						<%=HtmlUtil.getSelect(request, true, "STU_GBN", "STU_GBN", schLmsGbnStr, "", "class=\"select\" data-type=\"search\" style='width:100%;'") %>
					</td>
					<th>순번</th>					
					<td><input type="text" name="ORD_SEQ_GTEQ" value="" class="text" style="width:30%" data-type="search"  onkeydown="doSearch(true)" />~<input type="text" name="ORD_SEQ_LTEQ" style="width:30%" value=""  data-type="search" class="text"  onkeydown="doSearch(true)" /></td>	
					<th>권한자</th>
					<td><%=HtmlUtil.getSelect(request, true, "AUTH_CD", "", schAuthStr, "", "data-type=\"search\" style='width:100%;'") %></td>
					<td rowspan="3" class="verticalContainer">
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="getInList();"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
					</td>
				</tr>
				<tr>
					<th>기본상태코드</th>					
					<td><input type="text" name="STU_ID" value="" data-type="search" class="text" onkeydown="doSearch( true)" style="width:97%;" /></td>
					<th>기본상태명</th>					
					<td><input type="text" name="STU_NM" value="" data-type="search" class="text" onkeydown="doSearch( true)" style="width:97%;" /></td>
					<th>현재서식</th>
					<td><input type="text" class="text width_max" name="FORM_NO" id="FORM_NO" data-type="search"  onkeyup="doSearch(true)" style="width:97%;" /></td>
				</tr>
				<tr>
					<th>대상상태코드</th>					
					<td><input type="text" name="NEXT_STU_ID" value="" data-type="search" class="text" onkeydown="doSearch( true)" style="width:97%;" /></td>
					<th>대상상태명</th>					
					<td><input type="text" name="NEXT_STU_NM" value="" data-type="search" class="text" onkeydown="doSearch( true)" style="width:97%;" /></td>
					<th>대상서식</th>
					<td><input type="text" class="text width_max" name="NEXT_FORM_NO"  data-type="search"  onkeyup="doSearch(true)" style="width:97%;" /></td>
				</tr>
		</table>
</form>	
	</td>
		<td class="border_rm"></td>
	</tr>
	<tr>
		<td class="corner_lb"></td>
		<td class="border_mb"></td>
		<td class="corner_rb"></td>
	</tr>							
	</table>
	<br/>
	<br/>
<form name="saveForm" id="saveForm" method="post" onsubmit="return false;">
	<table class="basic">
	<tr>
		<th>법무구분</th>						
		<td colspan="3">
			<%=HtmlUtil.getSelect(request, true, "stu_gbn", "stu_gbn", schLmsGbnStr, "", "class=\"select\" data-type=\"search\"") %>
		</td>
		<td rowspan="5" style="text-align:center;">
			<span class="ui_btn medium icon"><span class="add"></span><a href="javascript:void(0)" onclick="goAddStu()"><%=StringUtil.getLocaleWord("B.ADD",siteLocale)%></a></span>		
			<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goDelete();"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>		
		</td>
	</tr>
	<tr>
		<th style="width:10%;">권한자</th>
		<td style="width:35%;" colspan="3">
			<%=HtmlUtil.getInputRadio(request, true, "auth_cd", userAuthStr, "", "", "") %>			
		</td>
	</tr>
	<tr>
		<th style="width:10%;">현재상태</th>						
		<td style="width:35%;">
			<input type="text" class="text width_max" name="stu_nm" id="stu_nm" placeholder="상태코드, 기본명 검색..." value=""/>
			<input type="hidden" name="stu_id" id="stu_id" value=""/>
		</td>
		<th style="width:10%;">폼 ID</th>						
		<td style="width:35%;">
			<input type="text" class="text width_max" name="form_no" id="form_no" placeholder="문서서식번호, 문서명 검색..."/>
		</td>
	</table>
</form>
	<br/>
	<br/>
	<br/>
<table class="basic">
<tr>
	<th style="text-align:center;width:5%">순번</th>
	<th style="text-align:center;width:5%">법무구분</th>
	<th style="text-align:center;width:15%">현재상태</th>
	<th style="text-align:center;width:10%">현재서식</th>
	<th style="text-align:center;width:10%">권한자</th>
	<th style="text-align:center;width:*">대상처리</th>
	<th style="text-align:center;width:5%"></th>
</tr>
<tbody id="inListBody">
</tbody>
</table>
<script>

$(function(){
	initOutList();
	getInList();
	
	$("#stu_nm").autocomplete({
		minLength:2,
		matchContains: false,
		source:function(request, response){
			var data = {"SCHWORD":$("#stu_nm").val(),"STU_GBN":$("#stu_gbn").val()};
			airCommon.callAjax("LMS_DEF_STU", "JSON_LIST",data, function(json){
				 response( jQuery.map( json.rows, function( item ) {
		              return {
		                //id: item.id,
		            	   value: item.STU_BASE_NM,
			                label: "["+item.STU_GBN+"]"+"["+item.STU_ID+"]"+item.STU_BASE_NM,
			                stu_id:item.STU_ID
		              }
		          }));
				
			});
			
		},select:function(e,u){
			$("#stu_id").val(u.item.stu_id);
		}
	});
	
	$("#form_no").autocomplete({
		minLength:2,
		matchContains: false,
		source:function(request, response){
			var data = {"SCHWORD":$("#form_no").val(),"MUNSEO_SEOSIG_NO":$("#stu_gbn").val()};
			airCommon.callAjax("SYS_DEF_DOC_MAIN", "JSON_LIST",data, function(json){
				 response( jQuery.map( json.rows, function( item ) {
		              return {
		                //id: item.id,
		            	  value: item.MUNSEO_SEOSIG_NO,
			                label: "["+item.MUNSEO_SEOSIG_NO+"]"+item.KO
		              }
		          }));
				
			});
			
		}
	});
	
})
</script>