
SUBROUTINE GB.JBL.V.DRAWN.TOSS.AC
    
*-----------------------------------------------------------------------------
* Subroutine Description:
* THIS ROUTINE is used to SET CREDIT.ACCOUNT as a Parking Ac for CHEQUE.TYPE like PO, PS, SDR
* Attach To: VERSION(TELLER,JBL.PO.LCY.CASHIN) , TELLER,JBL.INS.PAY.CASH.FOREIGN
*                    FUNDS.TRANSFER,JBL.INSTR.ISSUE.FOREIGN , FUNDS.TRANSFER,JBL.INSTR.ISSUE
*                    TELLER,JBL.INSTR.LCY.CASHIN.DD , TELLER,JBL.INSTR.LCY.CASHIN.TT.MT
*                    FUNDS.TRANSFER,JBL.INSTR.ISSUE.DD ,
* Attach As: VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/05/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
* 06/06/2024 -                             UPDATE -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
* ADD Foreign Part
* Parking AC Creation - CURRENCY will be fetched from CURRENCY1 in TT
*                      - CREDIT CURRENCY FOR FT.
* Fetch LT.PARKING.AC from CHEQUE.TYPE for Parking AC CATEGORY
*
* Fetch LT.BRANCH from TELLER/FUNDS.TRANSFER for Other Branch Parking AC Creation
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING CQ.ChqConfig
    $USING ST.CompanyCreation
    $USING EB.Foundation
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
    
    Y.ISS.CHQ.TYPE = ""
    
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
*
    Y.CATEG.AC = ""
    Y.COM = EB.SystemTables.getIdCompany()
    Y.COMPANY = EB.SystemTables.getIdCompany()[6,4]

    EB.DataAccess.FRead(FN.COM, Y.COM, Rec.Com, F.COM, Y.ERR)
    Y.SUB.DEV.CODE = Rec.Com<ST.CompanyCreation.Company.EbComSubDivisionCode>
    IF Y.SUB.DEV.CODE NE "" THEN
        Y.COMPANY = Y.SUB.DEV.CODE
    END
    
    Y.APP = EB.SystemTables.getApplication()
*
    IF Y.APP EQ "FUNDS.TRANSFER" THEN
        Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
        Y.CURRENCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditCurrency)
        
        FLD.POS = ""
        EB.Foundation.MapLocalFields("FUNDS.TRANSFER", "LT.ISS.OLD.CHQ", FLD.POS)
        Y.LT.ISS.OLD.CHQ.POS = FLD.POS<1,1>
        Y.TOTAL.LT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        Y.LT.ISS.OLD.CHQ = Y.TOTAL.LT<1,Y.LT.ISS.OLD.CHQ.POS>
        Y.ISS.CHQ.TYPE = Y.LT.ISS.OLD.CHQ
    
        APPLICATION.NAME = "CHEQUE.TYPE"
        Y.FILED.NAME = "LT.PARKING.AC"
        Y.FIELD.POS = ""
        EB.LocalReferences.GetLocRef(APPLICATION.NAME,Y.FILED.NAME,Y.FIELD.POS)
        EB.DataAccess.FRead(FN.CHEQUE.TYPE, Y.ISS.CHQ.TYPE, REC.CHQ.TYPE, F.CHEQUE.TYPE, Y.ERR)
        Y.CAT = REC.CHQ.TYPE<CQ.ChqConfig.ChequeType.ChequeTypeLocalRef,Y.FIELD.POS>
        
*------ credit the FTT main GL head account ---------*
        IF Y.ISS.CHQ.TYPE EQ "FTT" THEN
            Y.CAT = REC.CHQ.TYPE<CQ.ChqConfig.ChequeType.ChequeTypeAssignedCategory>
        END
*----- Fetch LT.BRANCH from FUNDS.TRANSFER for Other Branch Parking AC Creation ----------*
        IF Y.ISS.CHQ.TYPE EQ "DD" OR Y.ISS.CHQ.TYPE EQ "TT" OR Y.ISS.CHQ.TYPE EQ "MT" THEN
            APPLICATION.NAME = "FUNDS.TRANSFER"
            Y.FILED.NAME = "LT.BRANCH"
            Y.FIELD.POS.FT = ""
            EB.LocalReferences.GetLocRef(APPLICATION.NAME, Y.FILED.NAME, Y.FIELD.POS.FT)
            Y.COMPANY.NO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
            Y.COMPANY = Y.COMPANY.NO<1,Y.FIELD.POS.FT>
            Y.COMPANY = Y.COMPANY[6,4]
        END
*------ credit the FTT/TT/MT main GL head account ---------*
        IF Y.ISS.CHQ.TYPE EQ "FTT" OR Y.ISS.CHQ.TYPE EQ "TT" OR Y.ISS.CHQ.TYPE EQ "MT" THEN
            Y.CAT = REC.CHQ.TYPE<CQ.ChqConfig.ChequeType.ChequeTypeAssignedCategory>
        END
           
        Y.CATEG.AC = Y.CURRENCY:Y.CAT:"0001":Y.COMPANY
        EB.SystemTables.setComi(Y.CATEG.AC)
    END
    
    IF Y.APP EQ "TELLER" THEN
        Y.ISS.CHQ.TYPE = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
*---- Reversed TELLER.TRANSACTION for CHARGE deducted from the CASH AC ------------*
        Y.CURRENCY = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
        
        APPLICATION.NAME = "CHEQUE.TYPE"
        Y.FILED.NAME = "LT.PARKING.AC"
        Y.FIELD.POS = ""
        EB.LocalReferences.GetLocRef(APPLICATION.NAME,Y.FILED.NAME,Y.FIELD.POS)
        EB.DataAccess.FRead(FN.CHEQUE.TYPE, Y.ISS.CHQ.TYPE, REC.CHQ.TYPE, F.CHEQUE.TYPE, Y.ERR)
        Y.CAT = REC.CHQ.TYPE<CQ.ChqConfig.ChequeType.ChequeTypeLocalRef,Y.FIELD.POS>

*----- Fetch LT.BRANCH from TELLER for Other Branch Parking AC Creation ----------*
        IF Y.ISS.CHQ.TYPE EQ "DD" OR Y.ISS.CHQ.TYPE EQ "TT" OR Y.ISS.CHQ.TYPE EQ "MT" THEN
            APPLICATION.NAME = "TELLER"
            Y.FILED.NAME = "LT.BRANCH"
            Y.FIELD.POS.TT = ""
            EB.LocalReferences.GetLocRef(APPLICATION.NAME, Y.FILED.NAME, Y.FIELD.POS.TT)
            Y.COMPANY.NO = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
            Y.COMPANY = Y.COMPANY.NO<1,Y.FIELD.POS.TT>
            Y.COMPANY = Y.COMPANY[6,4]
        END
*------ credit the FTT/TT/MT main GL head account ---------*
        IF Y.ISS.CHQ.TYPE EQ "FTT" OR Y.ISS.CHQ.TYPE EQ "TT" OR Y.ISS.CHQ.TYPE EQ "MT" THEN
            Y.CAT = REC.CHQ.TYPE<CQ.ChqConfig.ChequeType.ChequeTypeAssignedCategory>
        END
    
        Y.CATEG.AC = Y.CURRENCY:Y.CAT:"0001":Y.COMPANY
        EB.SystemTables.setComi(Y.CATEG.AC)
    END
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "Y.PGM.VERSION: ": Y.PGM.VERSION : " Y.ISS.CHQ.TYPE: ": Y.ISS.CHQ.TYPE:" Y.CAT: ":Y.CAT:" Y.CATEG.AC : ":Y.CATEG.AC
    FileName = "SHIBLI_ISSUE_TOSS_AC_2024.txt"
    FilePath = "DL.BP"
*   FilePath = "D:\Temenos\t24home\default\SHIBLI.BP"
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

