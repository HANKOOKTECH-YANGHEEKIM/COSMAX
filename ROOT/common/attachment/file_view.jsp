<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@ page import="java.text.Normalizer" %>
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
            res.append("\n <table class=\"none\">          ");
            res.append("\n      <colgroup>                  ");
            res.append("\n          <col width=\"96%\" />   ");
            res.append("\n          <col width=\"4%\" />    ");
            res.append("\n      </colgroup>                 ");
            res.append("\n      <tr>                        ");
            res.append("\n          <td>&nbsp;</td>         ");
//             res.append("\n          <td align=\"center\">   ");
//             res.append("\n              <span class=\"ui_btn small icon\" ><span class=\"add\"></span><a href=\"javascript:airCommon.popupAfterAttachFileUpload('"+masterDocId+"','"+systemTypeCode+"','"+typeCode+"');\" ></a></span> ");
//             res.append("\n          </td>                   ");
            res.append("\n      </tr>                       ");
            res.append("\n </table>                         ");
        }
    }else{
        if (defaultViewResult != null && defaultViewResult.getRowCount() > 0
        		|| viewResult != null && viewResult.getRowCount() > 0) {
            res.append("\n <table class=\"none\">          ");
            res.append("\n      <colgroup>                  ");
            res.append("\n          <col width=\"96%\" />   ");
            res.append("\n          <col width=\"4%\" />    ");
            res.append("\n      </colgroup>                 ");
            res.append("\n      <tr>                ");
            res.append("\n          <td>            ");

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

            res.append("\n          </td>                   ");
//             res.append("\n          <td align=\"center\">   ");
//             res.append("\n              <span class=\"ui_btn small icon\" ><span class=\"add\"></span><a href=\"javascript:airCommon.popupAfterAttachFileUpload('"+masterDocId+"','"+systemTypeCode+"','"+typeCode+"');\" ></a></span> ");
//             res.append("\n          </td>                   ");
            res.append("\n      </tr>                       ");
            res.append("\n </table>                         ");
        }else{
            res.append("\n <table class=\"none\">          ");
            res.append("\n      <colgroup>                  ");
            res.append("\n          <col width=\"96%\" />   ");
            res.append("\n          <col width=\"4%\" />    ");
            res.append("\n      </colgroup>                 ");
            res.append("\n      <tr>                        ");
            res.append("\n          <td>&nbsp;</td>         ");
//             res.append("\n          <td align=\"center\">   ");
//             res.append("\n              <span class=\"ui_btn small icon\" ><span class=\"add\"></span><a href=\"javascript:airCommon.popupAfterAttachFileUpload('"+masterDocId+"','"+systemTypeCode+"','"+typeCode+"');\" ></a></span> ");
//             res.append("\n          </td> ");
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
    BeanResultMap responseMap         = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
    SQLResults defaultViewResult    = responseMap.getResult("DEFAULT_VIEW");
    SQLResults viewResult           = responseMap.getResult("VIEW");
    SQLResults docCreateUserInfo    = responseMap.getResult("DOC_CREATE_USER_INFO");

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
<%--
<%
    //-- 등록된 첨부가 있으면 보여줌
    if ((defaultViewResult != null && defaultViewResult.getRowCount() > 0) || (viewResult != null && viewResult.getRowCount() > 0)) {
        out.println("<ul class=\"attach_file_view\">");
        out.println(getAttachFileViewList(defaultViewResult, viewResult, is_show_history, showImage, typeCode, doc_mas_uid, systemTypeCode, isAddAtchAble));
        //out.println(getAttachFileViewList(viewResult, is_show_history, showImage, typeCode, doc_mas_uid, systemTypeCode, isAddAtchAble));
        out.println("</ul>");
    } else {
        //out.println(StringUtil.getLocaleWord("M.INFO_NOATTACHFILE",siteLocale));
        /* 카카오 법무팀의 요청으로 공백으로 처리(2014-03-25) */
        out.println("");
    }
%>
 --%>
<%
out.println("<ul class=\"attach_file_view\">");
out.println(getAttachFileViewList(defaultViewResult, viewResult, is_show_history, showImage, typeCode, doc_mas_uid, systemTypeCode, masterDocId, isAddAtchAble, loginUser));
out.println("</ul>");
%>