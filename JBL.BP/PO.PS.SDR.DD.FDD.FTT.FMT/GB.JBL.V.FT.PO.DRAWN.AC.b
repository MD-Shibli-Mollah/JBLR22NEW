
SUBROUTINE GB.JBL.V.FT.PO.DRAWN.AC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Subroutine Description:
* THIS ROUTINE is used to SET CREDIT.ACCOUNT for ALL types of CHEQUE.TYPE like PO, DD, PS, SDR, FDD, FTT, FMT
* Attach To: VERSION(FUNDS.TRANSFER,JBL.FDD.ISSUE, FUNDS.TRANSFER,JBL.FTT.ISSUE ,FUNDS.TRANSFER,JBL.FMT.ISSUE
*                    FUNDS.TRANSFER,JBL.PO.ISSUE.2, FUNDS.TRANSFER,JBL.PS.ISSUE.2, FUNDS.TRANSFER,JBL.SDR.ISSUE.2
*                    FUNDS.TRANSFER,JBL.DD.ISSUE.2, FUNDS.TRANSFER,JBL.TT.ISSUE.2, FUNDS.TRANSFER,JBL.MT.ISSUE.2

*
* Attach As: VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :

* 29/06/2024 -                             NEW - MD SHIBLI MOLLAH
*                                                   NITSL Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING CQ.ChqConfig
    $USING ST.CompanyCreation
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *
    GOSUB OPENFILE ; *
    GOSUB PROCESS ; *
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc> </desc>
    FN.CHEQUE.TYPE = "F.CHEQUE.TYPE"
    F.CHEQUE.TYPE = ""
    
    FN.COM = "F.COMPANY"
    F.COM = ""
RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc> </desc>
    EB.DataAccess.Opf(FN.CHEQUE.TYPE, F.CHEQUE.TYPE)
    EB.DataAccess.Opf(FN.COM, F.COM)
RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc> </desc>
    Y.CATEG.AC = ""
    
    Y.VER = EB.SystemTables.getPgmVersion()
    Y.COM = EB.SystemTables.getIdCompany()
    Y.COMPANY = EB.SystemTables.getIdCompany()[6,4]

    EB.DataAccess.FRead(FN.COM, Y.COM, Rec.Com, F.COM, Y.ERR)
    Y.SUB.DEV.CODE = Rec.Com<ST.CompanyCreation.Company.EbComSubDivisionCode>
* Financial Com : BD-001-9999
    Y.FIN.CODE = Rec.Com<ST.CompanyCreation.Company.EbComFinanFinanCom>
    Y.HO.CODE = Y.FIN.CODE[6,4]
    IF Y.SUB.DEV.CODE NE '' THEN
        Y.COMPANY = Y.SUB.DEV.CODE
    END
    
    Y.APP = EB.SystemTables.getApplication()
    
    IF Y.APP EQ "FUNDS.TRANSFER" THEN
        Y.ISS.CHQ.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        EB.DataAccess.FRead(FN.CHEQUE.TYPE, Y.ISS.CHQ.TYPE, REC.CHQ.TYPE, F.CHEQUE.TYPE, ERR)
        Y.CAT = REC.CHQ.TYPE<CQ.ChqConfig.ChequeType.ChequeTypeAssignedCategory>
        Y.CURRENCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditCurrency)
        
        IF Y.VER EQ ",JBL.FDD.ISSUE" OR Y.VER EQ ",JBL.FMT.ISSUE" OR Y.VER EQ ",JBL.FDD.FMT.ISSUE" THEN
            Y.COMPANY = Y.HO.CODE
        END
        IF Y.VER EQ "JBL.DD.ISSUE.2" OR Y.VER EQ ",JBL.TT.ISSUE.2" OR Y.VER EQ ",JBL.MT.ISSUE.2" THEN
            APPLICATION.NAME = "FUNDS.TRANSFER"
            Y.FILED.NAME = "LT.BRANCH"
            Y.FIELD.POS.FT = ""
            EB.LocalReferences.GetLocRef(APPLICATION.NAME, Y.FILED.NAME, Y.FIELD.POS.FT)
            Y.COMPANY.NO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
            Y.COMPANY = Y.COMPANY.NO<1,Y.FIELD.POS.FT>
            Y.COMPANY = Y.COMPANY[6,4]
        END
        
        Y.CATEG.AC = Y.CURRENCY:Y.CAT:"0001":Y.COMPANY
        EB.SystemTables.setComi(Y.CATEG.AC)
    END
    
    IF Y.APP EQ "TELLER" THEN
        Y.ISS.CHQ.TYPE = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        EB.DataAccess.FRead(FN.CHEQUE.TYPE, Y.ISS.CHQ.TYPE, REC.CHQ.TYPE, F.CHEQUE.TYPE, ERR)
        Y.CAT = REC.CHQ.TYPE<CQ.ChqConfig.ChequeType.ChequeTypeAssignedCategory>
        Y.CURRENCY = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyTwo)
        Y.CATEG.AC = Y.CURRENCY:Y.CAT:"0001":Y.COMPANY
        EB.SystemTables.setComi(Y.CATEG.AC)
    END
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "Y.ISS.CHQ.TYPE: ": Y.ISS.CHQ.TYPE:" Y.CAT: ":Y.CAT:" Y.CATEG.AC : ":Y.CATEG.AC
    FileName = 'SHIBLI_FDD_ISSUE_24.txt'
    FilePath = 'DL.BP'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*******--------------------------TRACER-END--------------------------------------------------------*********************
   
RETURN
*** </region>
END

