SUBROUTINE TF.JBL.E.CNV.DRW.TXN.ENTRY.MB
*-----------------------------------------------------------------------------
*Subroutine Description: Drawing's FT transaction showing
*Subroutine Type:
*Attached To    : JBL.ENQ.TXN.ENTRY.MB
*Attached As    : CONVERSION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 17/12/2019 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY.SELECT
    $INSERT I_GTS.COMMON
*
    $USING EB.Reports
    $USING EB.Foundation
    $USING LC.Contract
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.EntryCreation
    $USING AC.AccountOpening
    $USING ST.CompanyCreation
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
*-----
INIT:
*-----
    FN.DRAWINGS = 'FBNK.DRAWINGS'
    F.DRAWINGS  = ''
*
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT  = ''
*
    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS  = ''
*
    FN.STMT.ENT = 'F.STMT.ENTRY'
    F.STMT.ENT  = ''
*
    FN.ACCT = 'F.ACCOUNT'
    F.ACCT  = ''
*
    FN.COMP = 'F.COMPANY'
    F.COMP  = ''
    
    Y.FT.ID = ''
RETURN
*----------
OPENFILES:
*----------
    EB.DataAccess.Opf(FN.DRAWINGS, F.DRAWINGS)
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.FT.HIS, F.FT.HIS)
    EB.DataAccess.Opf(FN.STMT.ENT, F.STMT.ENT)
    EB.DataAccess.Opf(FN.ACCT, F.ACCT)
    EB.DataAccess.Opf(FN.COMP, F.COMP)
RETURN
*----------
PROCESS:
*----------
    Y.DRAWING.ID = EB.Reports.getOData()
    APPLICATION.NAME ='DRAWINGS'
    LOCAL.FIELD = 'LT.FT.REF.NO'
    EB.Foundation.MapLocalFields(APPLICATION.NAME, LOCAL.FIELD, Y.LC.LT.FLD.POS)
    EB.DataAccess.FRead(FN.DRAWINGS, Y.DRAWING.ID, REC.DRW, F.DRAWINGS, ERR.DRW)
    IF REC.DRW THEN
        Y.FT.ID = REC.DRW<LC.Contract.Drawings.TfDrLocalRef,Y.LC.LT.FLD.POS>
    END
    EB.DataAccess.FRead(FN.FT, Y.FT.ID, REC.FT, F.FT, ERR.FT)
    IF REC.FT EQ '' THEN
        EB.DataAccess.FRead(FN.FT.HIS, Y.FT.ID:';1', REC.FT, F.FT.HIS, ERR.FT)
    END
    IF REC.FT THEN
        Y.FT.STMT.ID  = REC.FT<FT.Contract.FundsTransfer.StmtNos,1>
    END
    Y.FT.STMT.ID.1 = FIELD(Y.FT.STMT.ID,'.',1)
    Y.FT.STMT.ID.2 = FIELD(Y.FT.STMT.ID,'.',2)
    FOR I=1 TO '4'
        Y.STMT.ENT.ID = Y.FT.STMT.ID.1:'.':FMT(Y.FT.STMT.ID.2, 'L%5'):I
        EB.DataAccess.FRead(FN.STMT.ENT, Y.STMT.ENT.ID, REC.STMT.ENT, F.STMT.ENT, ERR.STMT.ENT)
        IF REC.STMT.ENT THEN
            Y.STMT.VAL.DT = REC.STMT.ENT<AC.EntryCreation.StmtEntry.SteValueDate>
            Y.STMT.ACCT.NO = REC.STMT.ENT<AC.EntryCreation.StmtEntry.SteAccountNumber>
        END
        EB.DataAccess.FRead(FN.ACCT, Y.STMT.ACCT.NO, REC.ACCT, F.ACCT, ERR.ACCT)
        IF REC.ACCT THEN
            Y.CUS.ID = REC.ACCT<AC.AccountOpening.Account.Customer>
            Y.STMT.COMP.ID = REC.STMT.ENT<AC.EntryCreation.StmtEntry.SteCompanyCode>
        END
        EB.DataAccess.FRead(FN.COMP, Y.STMT.COMP.ID, REC.COMP, F.COMP, ERR.COPM)
        IF REC.COMP THEN
            Y.COMP.MNE = REC.COMP<ST.CompanyCreation.Company.EbComMnemonic>
            Y.STMT.CURR = REC.STMT.ENT<AC.EntryCreation.StmtEntry.SteCurrency>
            Y.STMT.FCY.AMT = REC.STMT.ENT<AC.EntryCreation.StmtEntry.SteAmountFcy>
            Y.STMT.LCY.AMT = REC.STMT.ENT<AC.EntryCreation.StmtEntry.SteAmountLcy>
        END
        Y.RETURN<-1> = Y.STMT.VAL.DT:"*":Y.STMT.ACCT.NO:"*":Y.CUS.ID:"*":Y.COMP.MNE:"*":Y.STMT.CURR:"*":Y.STMT.FCY.AMT:"*":Y.STMT.LCY.AMT:"*":Y.STMT.ENT.ID
    NEXT I
    CONVERT FM TO '|' IN Y.RETURN
    EB.Reports.setOData(Y.RETURN)
RETURN
END
