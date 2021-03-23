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
	   		   + "&AIR_MODE=JSON_LIST";
%>
<script type="text/javascript">
	
	 /**
	  * 검색 수행
	  */ 
	 function doSearch(isCheckEnter) {
		
		 getLmsDefDocStuOut(isCheckEnter);
		 
	 }
	 
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
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"대상상태")%>");
			$("#stu_id").eq(0).focus();
		    return false;	
		}
		var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.ADD")%>";
		if(confirm(msg)){
			var data = $("#saveForm").serialize();
			airCommon.callAjax("<%=actionCode%>", "WRITE_OUT_PROC",data, function(json){
// 				document.saveForm.reset();
				getLmsDefDocStuOut();
			});
		}
	}
	
	var imsiVal = {};	//-- 임시 값 수정
	var setImsiVal = function(key, val){
		imsiVal[key] = val;
	}
	//-- 순번 수정
	var goModStr = function(isCheckEnter,orgData, uuid, obj){
		
		var col = $(obj).attr("name");
		
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
			airCommon.callAjax("<%=actionCode%>", "WRITE_OUT_PROC",data, function(json){
				getLmsDefDocStuOut();
			});
		}else{
			$(obj).val(imsiVal[col]);
			imsiVal[col] = "";
		}
	
	}
	//-- 권한자 수정
	var goModAuth = function(orgData, uuid, obj){

		setImsiVal("AUTH_CD", orgData);
	 	
		var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.MODIFY")%>";
		if(confirm(msg)){
			var data = {};
			data["UUID"] =uuid;
			data["AUTH_CD"] =$(obj).val();
			airCommon.callAjax("<%=actionCode%>", "WRITE_OUT_PROC", data, function(json){
				getLmsDefDocStuOut();
			});
		}else{
			$(obj).val(imsiVal["AUTH_CD"]);
			imsiVal["AUTH_CD"] = "";
		}
	
	}
</script>
<script type="text/javascript" src="/common/_lib/jquery-ui/jquery-ui.js"></script>
<form name="form1" method="post">
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
					<td>
						<input type="text" name="ORD_SEQ_GTEQ" value="" data-type="search" onkeydown="doSearch(true)" class="text" style="width:30%" />
						~ 
						<input type="text" name="ORD_SEQ_LTEQ" value="" data-type="search" onkeydown="doSearch(true)" class="text" style="width:30%" />
					</td>	
					<th>권한자</th>
					<td><%=HtmlUtil.getSelect(request, true, "AUTH_CD", "", schAuthStr, "", "data-type=\"search\" style='width:100%;'") %>	</td>
					<td rowspan="3" class="verticalContainer">
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="getLmsDefDocStuOut();"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
					</td>
				</tr>
				<tr>
					<th>현재상태</th>					
					<td><input type="text" name="STU_NM" value="" data-type="search" class="text" onkeydown="doSearch( true)" style="width:97%;" /></td>
					<th colspan="3">현재폼 NO</th>
					<td><input type="text" class="text width_max" name="FORM_NO" id="FORM_NO" data-type="search" onkeyup="doSearch(true)" style="width:97%;" /></td>
				</tr>
				<tr>
					<th>다음상태</th>
					<td><input type="text" class="text width_max" name="NEXT_STU_NM" id="NEXT_STU_NM" data-type="search"  onkeyup="doSearch(true)" style="width:97%;" /></td>
					<th colspan="3">다음폼 NO</th>
					<td><input type="text" class="text width_max" name="NEXT_FORM_NO" id="NEXT_FORM_NO" data-type="search"  onkeyup="doSearch(true)" style="width:97%;" /></td>
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
</form>	
	<br/>
	<br/>
<form name="saveForm" id="saveForm" method="post">
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
	</tr>
	<tr>
		<th>대상상태</th>
		<td>
			<input type="text" class="text width_max" name="next_stu_nm" id="next_stu_nm" placeholder="상태코드, 기본명 검색..." value=""/>
			<input type="hidden" name="next_stu_id" id="next_stu_id" value=""/>
		</td>
		<th>다음폼 NO</th>
		<td><input type="text" class="text width_max"  name="next_form_no" id="next_form_no" placeholder="문서서식번호, 문서명 검색..."/></td>
	</tr>
	</table>
</form>
	<br/>
	<br/>
	<br/>
	<!--
	{
		"type":"onBlur"
		,"href":"goModStr(false,\"@{UUID}\",this)"
	},
	  -->
<table class="list" id="LmsDefDocStuRelTable">
	<thead>
	<tr>
		<th style="width:5%"   data-opt='{"align":"center","inputHidden":"UUID;STU_GBN;STU_ID"
			,"html":{"type":"text"
					,"class":"text width_max"
					,"name":"ORD_SEQ"
					,"event":[{
						"type":"onKeyUp"
						,"href":"goModStr(true,\"@{ORD_SEQ}\",\"@{UUID}\",this)"
					}]
			}
		}'>순번</th>
		<th style="width:5%" data-opt='{"align":"center","col":"STU_GBN_NM"}'>법무구분</th>
<!-- 		<th style="width:8%" data-opt='{"align":"center","col":"AUTH_NM"}'>권한자</th> -->
		<th style="width:5%"   data-opt='{"align":"center"
			,"html":{"type":"combobox"
					,"name":"AUTH_CD"
					,"options":{
						"valueField":"value",
						"textField":"label",
						"data":[
							<%=selData%>
						]
					},"event":[{
						"type":"onChange"
						,"href":"goModAuth(\"@{AUTH_CD}\",\"@{UUID}\",this)"
					}]
			}
		}'>권한자</th>
<!-- 		<th style="width:10%" data-opt='{"align":"center","col":"STU_ID"}'>현재상태ID</th> -->
		<th style="width:10%"   data-opt='{"align":"center"
			,"html":{"type":"text"
					,"class":"text width_max"
					,"name":"STU_ID"
					,"event":[{
						"type":"onKeyUp"
						,"href":"goModStr(true,\"@{STU_ID}\",\"@{UUID}\",this)"
					},{
						"type":"onfocus"
						,"href":"setImsiVal(this.value)"
					}]
			}
		}'>현재상태ID</th>
		<th style="width:*" data-opt='{"align":"left","col":"STU_NM"}'>현재상태명</th>
<!-- 		<th style="width:12%" data-opt='{"align":"center","col":"FORM_NO"}'>현재폼 NO</th> -->
		<th style="width:10%"   data-opt='{"align":"center"
			,"html":{"type":"text"
					,"class":"text width_max"
					,"name":"FORM_NO"
					,"event":[{
						"type":"onKeyUp"
						,"href":"goModStr(true,\"@{FORM_NO}\",\"@{UUID}\",this)"
					}]
			}
		}'>현재폼 NO</th>
<!-- 		<th style="width:*" data-opt='{"align":"left","col":"NEXT_STU_ID"}'>대상상태ID</th> -->
		<th style="width:12%"   data-opt='{"align":"center"
			,"html":{"type":"text"
					,"class":"text width_max"
					,"name":"NEXT_STU_ID"
					,"event":[{
						"type":"onKeyUp"
						,"href":"goModStr(true,\"@{NEXT_STU_ID}\",\"@{UUID}\",this)"
					}]
			}
		}'>대상상태ID</th>
		<th style="width:*" data-opt='{"align":"left","col":"NEXT_STU_NM"}'>대상상태명</th>
<!-- 		<th style="width:12%" data-opt='{"align":"center","col":"NEXT_FORM_NO"}'>다믐폼NO</th> -->
		<th style="width:10%"   data-opt='{"align":"center"
			,"html":{"type":"text"
					,"class":"text width_max"
					,"name":"NEXT_FORM_NO"
					,"event":[{
						"type":"onKeyUp"
						,"href":"goModStr(true,\"@{NEXT_FORM_NO}\",\"@{UUID}\",this)"
					}]
			}
		}'>다믐폼NO</th>
		<th style="width:8%" data-opt='{"align":"center","html":{"type":"BTN","class":"delete","callback":"goRowDelete(\"@{UUID}\")","title":"<%=StringUtil.getLocaleWord("L.삭제",siteLocale)%>"}}'></th>
	</tr>
	</thead>
	<tbody id="LmsDefDocStuRelTableBody"></tbody>
</table>
<%-- 페이지 목록 --%>
<!-- <div class="pagelist" id="LmsDefDocStuRelTablePage"></div>  -->
<script>
var goRowDelete = function(uuid){
	var msg = "<%=StringUtil.getLocaleMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>";
	if(confirm(msg)){
		airCommon.callAjax("<%=actionCode%>", "DELETE_OUT_PROC",{"UUID":uuid}, function(json){
			 getLmsDefDocStuOut();
		});
	}
}
//--  리스트
var getLmsDefDocStuOut = function(isCheckEnter){
	
	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
	var data = airCommon.getSearchQueryParams();
	  
	airCommon.callAjax("<%=actionCode%>", "JSON_OUT_LIST",data, function(json){
	  airCommon.createTableRow("LmsDefDocStuRelTable", json);
	});
};
$(function(){
	getLmsDefDocStuOut();
	
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
			                label: "["+item.STU_ID+"]"+item.STU_BASE_NM,
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
	
	$("#next_stu_nm").autocomplete({
		minLength:2,
		matchContains: false,
		source:function(request, response){
			var data = {"SCHWORD":$("#next_stu_nm").val(),"STU_GBN":$("#stu_gbn").val()};
			airCommon.callAjax("LMS_DEF_STU", "JSON_LIST",data, function(json){
				 response( jQuery.map( json.rows, function( item ) {
		              return {
		                //id: item.id,
		            	  value: item.STU_BASE_NM,
			                label: "["+item.STU_ID+"]"+item.STU_BASE_NM,
			                stu_id:item.STU_ID
		              }
		          }));
				
			});
			
		},select:function(e,u){
			$("#next_stu_id").val(u.item.stu_id);
		}
	});
	
	
	$("#next_form_no").autocomplete({
		minLength:2,
		matchContains: false,
		source:function(request, response){
			var data = {"SCHWORD":$("#next_form_no").val(),"MUNSEO_SEOSIG_NO":$("#stu_gbn").val()};
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