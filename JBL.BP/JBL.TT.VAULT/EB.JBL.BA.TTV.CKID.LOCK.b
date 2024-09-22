SUBROUTINE EB.JBL.BA.TTV.CKID.LOCK
*--------------------------------------------------------------------------------
* Subroutine Description:
*
* Attach To: VERSION - EB.JBL.TT.VAULT,INPUTT
* Attach As: BEFORE AUTH ROUTINE
*-----------------------------------------------------------------------------

* Modification History :  Retrofit from TTV.CKID.LOCK
* 22/09/2024 -                          NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
*
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    
    $INSERT I_F.EB.JBL.TT.VAULT
    
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.DataAccess
    $USING ST.Config
    $USING ST.CompanyCreation
    $USING TT.Config
    $USING EB.ErrorProcessing

    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()
    
    FN.V = 'F.EB.JBL.TT.VAULT$NAU'
    F.V = ''
    EB.DataAccess.Opf(FN.V,F.V)
    EB.DataAccess.FRead(FN.V, Y.ID.NEW, R.CK, F.V, ERR.CK)
    
    Y.TTV.DATE = R.CK<EB.TT.83.DATE.TIME><1,1>[1,6]
* Y.DT = '20':R.CK<TTV.DATE.TIME><1,1>[1,6]
    Y.DT = '20':Y.TTV.DATE
    Y.NDT = DATE() "D4/"
    Y.NDT = FIELD(Y.NDT,'/',3):FIELD(Y.NDT,'/',1):FIELD(Y.NDT,'/',2)
    
    IF Y.DT LT Y.NDT THEN
* AF = 0
        EB.SystemTables.setAf(0)
* ETEXT = 'Back Dated Entry Can not be authorised.'
        EB.SystemTables.setEtext('Back Dated Entry Can not be authorised.')
* CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
RETURN
END


