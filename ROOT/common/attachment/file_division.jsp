<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.Normalizer" %>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%!
// 첨부파일 뷰 목록 출력 도우미 메소드
private static String getAttachFileViewList(SQLResults defaultViewResult, SQLResults viewResult, boolean isShowHistory, String showImage, String typeCode, String doc_mas_uid, String systemTypeCode, String masterDocId, boolean isAddAtchAble,SysLoginModel loginUser)
{
    StringBuffer res = new StringBuffer();
    
    if(isAddAtchAble){
        if (defaultViewResult != null && defaultViewResult.getRowCount() > 0
        		|| viewResult != null && viewResult.getRowCount() > 0) {
            res.append("\n <table class=\"none\"> ");
            res.append("\n      <colgroup> ");
            res.append("\n          <col width=\"96%\" /> ");
            res.append("\n          <col width=\"4%\" /> ");
            res.append("\n      </colgroup> ");
            res.append("\n      <tr> ");
            res.append("\n          <td> ");

            for(int z =0; z < 2; z++){
                SQLResults rs = null;
                if(z==0){
                    rs = defaultViewResult;
                }else if(z==1){
                    rs = viewResult;
                }
                if(rs != null && rs.getRowCount()> 0){
					//-- 파일이 하나라도 있다면 해당 버튼 표출
					if(rs.getRowCount() > 1){
	                	res.append("\n          <span class=\"ui_btn small icon\" ><span class=\"confirm\"></span><a href=\"javascript:void(0)\" onclick=\"airCommon.zipFileDownload('"+typeCode+"','"+masterDocId+"',function(data){alert(data.result)})\">");
	                	res.append("ALL DOWN");
	                	res.append("</a></span>");
					}
                    for (int i = 0; i < rs.getRowCount(); i++) {
                        String uuid             = rs.getString(i, "uuid");
                        String file_name        = rs.getString(i, "file_name");
                        String file_size        = rs.getString(i, "file_size");
                        String file_savename    = rs.getString(i, "file_savename");
                        String file_after_add_yn= rs.getString(i, "file_after_add_yn");
                        String insert_user_name = rs.getString(i, "insert_user_name");
                        String insert_date      = rs.getString(i, "insert_date");

                        String aTitle = insert_user_name + "[" + insert_date + "]";

                        res.append("\n <li>");
                        if (isShowHistory) res.append("\n <input type=\"button\" value=\"이력\" class=\"btn35s\" onclick=\"airCommon.popupAttachFileHistory('"+ uuid +"');\" /> ");

                        if("Y".equals(showImage)){
                            res.append("\n <input type=\"radio\" name=\"fileRadio"+doc_mas_uid+"\" value=\"/ServletController?AIR_ACTION=SYS_ATCH&AIR_MODE=FILE_SRC&type_code="+ typeCode+ "&file_savename="+file_savename+"\" onclick=\"javascript:showImage"+doc_mas_uid+"(this.value)\"/> ");
                        }

                        if("Y".equals(file_after_add_yn)){
                            res.append("\n <a style=\"color:green\" href=\"javascript:airCommon.popupAttachFileDownload('"+ uuid +"')\" title=\""+aTitle+"\">"+ Normalizer.normalize(StringUtil.convertForInput(file_name), Normalizer.Form.NFC) +"</a>");
                        }else{
                            res.append("\n <a href=\"javascript:airCommon.popupAttachFileDownload('"+ uuid +"')\" title=\""+aTitle+"\">"+ Normalizer.normalize(StringUtil.convertForInput(file_name), Normalizer.Form.NFC) +"</a>");
                        }
                        res.append("\n </li>");
                    }
                }
            }

            res.append("\n          </td> ");
//             res.append("\n          <td align=\"center\">   ");
//             res.append("\n              <span class=\"ui_btn small icon\" ><span class=\"add\"></span><a href=\"javascript:airCommon.popupAfterAttachFileUpload('"+masterDocId+"','"+systemTypeCode+"','"+typeCode+"');\" ></a></span> ");
//             res.append("\n          </td>                   ");
            res.append("\n      </tr>                       ");
            res.append("\n </table>                         ");
        }else{
            res.append("\n <table class=\"none\"> ");
            res.append("\n      <colgroup> ");
            res.append("\n          <col width=\"96%\" /> ");
            res.append("\n          <col width=\"4%\" /> ");
            res.append("\n      </colgroup> ");
            res.append("\n      <tr> ");
            res.append("\n          <td>&nbsp;</td> ");
            res.append("\n      </tr> ");
            res.append("\n </table> ");
        }
    }else{
        if (defaultViewResult != null && defaultViewResult.getRowCount() > 0
        		|| viewResult != null && viewResult.getRowCount() > 0) {
            res.append("\n <table class=\"list\"> ");
            res.append("\n      <colgroup> ");
            res.append("\n          <col style=\"width:auto\" /> ");
            res.append("\n          <col style=\"width:68%\" /> ");
            res.append("\n      </colgroup> ");
            res.append("\n      <tr> ");
            res.append("\n          <th>File</th> ");
            res.append("\n          <th>페이지 분할</th> ");
            res.append("\n      </tr> ");

            for(int z =0; z < 2; z++){
                SQLResults rs = null;
                if(z==0){
                    rs = defaultViewResult;
                }else if(z==1){
                    rs = viewResult;
                }
                if(rs != null && rs.getRowCount()> 0){
                    for (int i = 0; i < rs.getRowCount(); i++) {
                        String uuid             = rs.getString(i, "uuid");
                        String file_name        = rs.getString(i, "file_name");
                        String file_size        = rs.getString(i, "file_size");
                        String file_savename    = rs.getString(i, "file_savename");
                        String file_after_add_yn= rs.getString(i, "file_after_add_yn");
                        String insert_user_name = rs.getString(i, "insert_user_name");
                        String insert_date      = rs.getString(i, "insert_date");
                        
                        String aTitle = insert_user_name + "[" + insert_date + "]";
                        
                        // PDF 분할된 파일인 경우 원본 첨부 리스트에서 제외
                        // 분할된 파일은 분할 영역에 표시된다.
                        String org_file_savename = rs.getString(i, "org_file_savename");
                        if (!StringUtil.isBlank(org_file_savename)) continue;
                        


            res.append("\n      <tr> ");
            res.append("\n          <td> ");
            
                        res.append("\n <li>");
                        if (isShowHistory) res.append("\n <input type=\"button\" value=\"이력\" class=\"btn35s\" onclick=\"airCommon.popupAttachFileHistory('"+ uuid +"');\" /> ");

                        if("Y".equals(showImage)){
                            res.append("\n <input type=\"radio\" name=\"fileRadio"+doc_mas_uid+"\" value=\"/ServletController?AIR_ACTION=SYS_ATCH&AIR_MODE=FILE_SRC&type_code="+ typeCode+ "&file_savename="+file_savename+"\" onclick=\"javascript:showImage"+doc_mas_uid+"(this.value)\"/> ");
                        }

                        if("Y".equals(file_after_add_yn)){
                            res.append("\n <a style=\"color:green\" href=\"javascript:airCommon.popupAttachFileDownload('"+ uuid +"')\" title=\""+aTitle+"\">"+ Normalizer.normalize(StringUtil.convertForInput(file_name), Normalizer.Form.NFC) +"</a>");
                        }else{
                            res.append("\n <a href=\"javascript:airCommon.popupAttachFileDownload('"+ uuid +"')\" title=\""+aTitle+"\">"+ Normalizer.normalize(StringUtil.convertForInput(file_name), Normalizer.Form.NFC) +"</a>");
                        }
                        res.append("\n </li>");

            res.append("\n          </td> ");
            res.append("\n          <td> ");
            
            res.append("\n          <table class=\"none\"> ");
            res.append("\n          <colgroup> ");
            res.append("\n          	<col style='width:auto;'> ");
            res.append("\n          	<col style='width:140px;'> ");
            res.append("\n          </colgroup> ");
            res.append("\n          <tr> ");
           
            Boolean isDivision = false;
           
            for (int idxDiv = 0; idxDiv < rs.getRowCount(); idxDiv++) {
                String div_uuid             = rs.getString(idxDiv, "uuid");
                String div_file_name        = rs.getString(idxDiv, "file_name");
                String div_file_size        = rs.getString(idxDiv, "file_size");
                String div_file_savename    = rs.getString(idxDiv, "file_savename");
                String div_file_after_add_yn= rs.getString(idxDiv, "file_after_add_yn");
                String div_insert_user_name = rs.getString(idxDiv, "insert_user_name");
                String div_insert_date      = rs.getString(idxDiv, "insert_date");
                
                String div_aTitle = div_insert_user_name + "[" + div_insert_date + "]";
                
                String div_org_file_savename = rs.getString(idxDiv, "org_file_savename");
                if (StringUtil.isBlank(div_org_file_savename)) continue;
                
                if ( div_org_file_savename.equals(file_savename))
                {
                	if ( !isDivision ) {
                		isDivision = true;
                		res.append("\n            <td> ");
                	}
                	
                	res.append("\n <li>");
                    if (isShowHistory) res.append("\n <input type=\"button\" value=\"이력\" class=\"btn35s\" onclick=\"airCommon.popupAttachFileHistory('"+ div_uuid +"');\" /> ");

                    if("Y".equals(showImage)){
                        res.append("\n <input type=\"radio\" name=\"fileRadio"+doc_mas_uid+"\" value=\"/ServletController?AIR_ACTION=SYS_ATCH&AIR_MODE=FILE_SRC&type_code="+ typeCode+ "&file_savename="+div_file_savename+"\" onclick=\"javascript:showImage"+doc_mas_uid+"(this.value)\"/> ");
                    }

                    if("Y".equals(div_file_after_add_yn)){
                        res.append("\n <a style=\"color:green\" href=\"javascript:airCommon.popupAttachFileDownload('"+ div_uuid +"')\" title=\""+div_aTitle+"\">"+ Normalizer.normalize(StringUtil.convertForInput(div_file_name), Normalizer.Form.NFC) +"</a>");
                    }else{
                        res.append("\n <a href=\"javascript:airCommon.popupAttachFileDownload('"+ div_uuid +"')\" title=\""+div_aTitle+"\">"+ Normalizer.normalize(StringUtil.convertForInput(div_file_name), Normalizer.Form.NFC) +"</a>");
                    }
                    res.append("\n </li>");
                }
                
                if ( isDivision &&  rs.getRowCount()-1 == idxDiv) {
            		res.append("\n            </td> ");
            	}
            }
            
            // 분할되지 않고 확장자가 pdf 파일인 경우
            if(!isDivision && file_name.toUpperCase().endsWith("PDF")){
        	    res.append("\n            <td id=\"td_division"+uuid+"\" data-meaning='div_f' data-uuid=\""+uuid+"\"></td> ");
         		res.append("\n            <td style=\"vertical-align:top;\">");
	            res.append("\n            <span id=\"btn_division"+uuid+"\">");
	            res.append("\n          		<span class=\"ui_btn medium\"><a onclick=\"doPlus('"+uuid+"','"+file_name+"');\" style=\"width:13px; text-align:center;\">+</a></span>");
	            res.append("\n          		&nbsp;");           
	            res.append("\n            		<span id=\"btn_"+ uuid +"\" class=\"ui_btn medium icon\"><span class=\"write\"></span><a onclick=\"doDivisionStart('"+uuid+"', '"+file_name+"', '"+file_savename+"');\">").append(StringUtil.getLocaleWord("B.분할시작","KO")).append("</a></span>");
	            res.append("\n            </span>");
            }
            res.append("\n            </td>");
            res.append("\n      	</tr> ");
            res.append("\n 			</table> ");
            
            res.append("\n          </td> ");            
                    }
                }
            }

            res.append("\n </table> ");
        }else{
            res.append("\n <table class=\"none\"> ");
            res.append("\n      <colgroup> ");
            res.append("\n          <col width=\"96%\" /> ");
            res.append("\n          <col width=\"4%\" /> ");
            res.append("\n      </colgroup> ");
            res.append("\n      <tr> ");
            res.append("\n          <td>&nbsp;</td>         ");
            res.append("\n      </tr> ");
            res.append("\n </table> ");
        }
    }

    return res.toString();
}
%>
<%
    //-- 로그인 사용자 정보 셋팅
    SysLoginModel loginUser     = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
    String siteLocale           = loginUser.getSiteLocale();

    String doc_mas_uid          = request.getParameter("doc_mas_uid");
    //-- 검색값 셋팅
    BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String masterDocId          = requestMap.getString("MASTERDOCID");
    String systemTypeCode       = requestMap.getString("SYSTEMTYPECODE");
    String typeCode             = requestMap.getString("TYPECODE");
    String showImage            = requestMap.getString("SHOWIMAGE");         //이미지 파일을 보여주기 위한 필드 Y일경우 showImage() function이 필요.

    //-- 결과값 셋팅
    BeanResultMap responseMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
    SQLResults defaultViewResult = responseMap.getResult("DEFAULT_VIEW");
    SQLResults viewResult = responseMap.getResult("VIEW");
    SQLResults docCreateUserInfo = responseMap.getResult("DOC_CREATE_USER_INFO");

    List<Object> realViewResult		= new ArrayList<Object>();

    //-- 파라메터 셋팅
    String actionCode           = responseMap.getString(CommonConstants.ACTION_CODE);
    String modeCode             = responseMap.getString(CommonConstants.MODE_CODE);

    String saengseongja_dpt_cod = "";
    String saengseongja_id      = "";
    if(docCreateUserInfo != null && docCreateUserInfo.getRowCount() > 0){
        saengseongja_dpt_cod = docCreateUserInfo.getString(0,"saengseongja_dpt_cod");
        saengseongja_id      = docCreateUserInfo.getString(0,"saengseongja_id");
    }

    boolean isAddAtchAble = false;

    if("SD".equals(systemTypeCode) || "CMM/CMM".equals(typeCode)){
        if(!"".equals(saengseongja_id)){
            if(loginUser.isManager()){
                    isAddAtchAble = true;
            }else{
                if(saengseongja_dpt_cod.equals(loginUser.getGroupCode())){
                    isAddAtchAble = true;
                }
            }
        }
    }

    //-- 파일이력 보기 버튼 보이기 여부
    boolean is_show_history     = ((loginUser.isEmfAdmin() && "Y".equals(CommonProperties.load("fnc.fileHistroy"))) ? true : false);
%>
<form id="fileDivisionForm" name="fileDivisionForm" method="POST">
<%
out.println("<ul class=\"attach_file_view\">");
out.println(getAttachFileViewList(defaultViewResult, viewResult, is_show_history, showImage, typeCode, doc_mas_uid, systemTypeCode, masterDocId, isAddAtchAble, loginUser));
out.println("</ul>");
%>
</form>
<script>
var setBtnView = function(vUUID){
	
	if($("#td_division"+vUUID).find("div").length == 0){
		$("td[data-meaning='div_f']").each(function(i, e){
			$("#btn_division"+$(e).data("uuid")).show();
		});
		maxFileCnt = 0;
	}else{
		$("td[data-meaning='div_f']").each(function(i, e){
			if(vUUID != $(e).data("uuid")){
				$("#btn_division"+$(e).data("uuid")).hide();
			}
		});
	}
}
var maxFileCnt = 0;
var doPlus = function(vUUID, fileName){
	
	var imsiFileName = fileName.substring(0, fileName.lastIndexOf('.')) +'_'+(maxFileCnt+1)+'.pdf'
	var uuid = airCommon.getRandomUUID();
	
	var div = $("<div>");
	div.attr("id",uuid);
	div.append(	$("<input type='text' name='page_from' placeholder='시작' class='number' style='width:30px;' data-type='search' />"));
	div.append(" ~ ");
	div.append(	$("<input type='text' name='page_to' placeholder='종료' class='number' style='width:30px;' data-type='search' />"));
	div.append("  ");
	div.append(	$("<input type='text' name='file_name' placeholder='분할후 파일명 입력.' style='width:270px;' value='"+imsiFileName+"' data-type='search' />"));
	div.append("&nbsp;&nbsp;");
	div.append(	$("<span class=\"ui_btn medium\" ><a onclick=\"doMinus('"+uuid+"', '"+vUUID+"');\" style=\"width:13px; text-align:center;\">-</a></span>"));
	
	$("#td_division"+vUUID).append(div);
	
	maxFileCnt++;
	setBtnView(vUUID);
}

var doMinus = function(vUUID, vparentUUID){
	$("#"+vUUID).remove();
	setBtnView(vparentUUID);
}

var checkVal = function(vFileUUID) {
	
	var divCnt = $("#td_division"+vFileUUID).find("div").length;
	var bool = true;
	if(divCnt > 0){
		for(var i=0; i< divCnt; i++){
			if($("input:text[name='page_from']").eq(i).val() == ""){
				alert("시작페이지를 입력해 주세요");
				$("input:text[name='page_from']").eq(i).focus();
				bool = false;
				return false;
			}
			if($("input:text[name='page_to']").eq(i).val() == ""){
				alert("종료페이지를 입력해 주세요");
				$("input:text[name='page_to']").eq(i).focus();
				bool = false;
				return false;
			}
			if($("input:text[name='file_name']").eq(i).val() == ""){
				alert("파일명을 입력해 주세요");
				$("input:text[name='file_name']").eq(i).focus();
				bool = false;
				return false;
			}
		}
		
	}else{
		alert("div가 없음");
		bool = false;
	}
	
	return bool;
}
</script>