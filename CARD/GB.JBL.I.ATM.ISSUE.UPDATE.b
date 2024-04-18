* @ValidationCode : MjotMTYzNTUzMTIwMzpDcDEyNTI6MTcwNTMxNzAzMjE2MzpuYXppaGFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Jan 2024 17:10:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* THIS ROUTINE USE FOR UPDATE DATA OF ALL VERSION
* Developed By: Md. Robiul Islam
*Deploy Date: 12 JAN 2017
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.I.ATM.ISSUE.UPDATE
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :31/12/2023
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for ATM CARD MANAGEMENT SYSTEM
*                         to check the FT and CARD Validation in every stage
* Subroutine Type: INPUT
* Attached To    : EB.JBL.ATM.CARD.MGT,CLOSE ; EB.JBL.ATM.CARD.MGT,CLOSEBR ; EB.JBL.ATM.CARD.MGT,CLOSEHO
*				   EB.JBL.ATM.CARD.MGT,DELIVERY ; EB.JBL.ATM.CARD.MGT,DENIED ; EB.JBL.ATM.CARD.MGT,ISSUE
*				   EB.JBL.ATM.CARD.MGT,PINHO ; EB.JBL.ATM.CARD.MGT,PINREQ ; EB.JBL.ATM.CARD.MGT,RECEIVED
*				   EB.JBL.ATM.CARD.MGT,REISSUE ; EB.JBL.ATM.CARD.MGT,UPDATE ; EB.JBL.ATM.CARD.MGT,WAIVE

* Attached As    : INPUT ROUTINE
* TAFC Routine Name : ATM.ISSUE.UPDATE - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
* $INSERT GLOBUS.BP I_F.FUNDS.TRANSFER
    $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.Interface
    $USING EB.ErrorProcessing
    $USING EB.TransactionControl
    $USING EB.API
       
*    Y.COMP.OFSOPS = EB.Interface.getOfsOperation()
    
*    IF Y.COMP.OFSOPS EQ "VALIDATE" THEN
*        RETURN
*    END
    
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ""
    FN.ATM.NAU = "F.EB.JBL.ATM.CARD.MGT$NAU"
    F.ATM.NAU = ""
    FN.ATM.HIS = "F.EB.JBL.ATM.CARD.MGT$HIS"
    F.ATM.HIS = ""

    FN.FT.NAU = "F.FUNDS.TRANSFER$NAU"
    F.FT.NAU = ""
    FN.FT = "F.FUNDS.TRANSFER"
    F.FT = ""
    FN.FT.HIS = "F.FUNDS.TRANSFER$HIS"
    F.FT.HIS = ""
    
    EB.DataAccess.Opf(FN.ATM,F.ATM)
    EB.DataAccess.Opf(FN.ATM.NAU,F.ATM.NAU)
    EB.DataAccess.Opf(FN.ATM.HIS,F.ATM.HIS)
    EB.DataAccess.Opf(FN.FT.NAU,F.FT.NAU)
    EB.DataAccess.Opf(FN.FT,F.FT)
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)

    Y.ACCOUNT = EB.SystemTables.getRNew(EB.ATM19.ACCT.NO)
    
    EB.DataAccess.Opf(FN.AC,F.AC)
    EB.DataAccess.FRead(FN.AC,Y.ACCOUNT,R.AC.REC,F.AC,Y.ERR)
    Y.CATEGORY = R.AC.REC<AC.AccountOpening.Account.Category>
    Y.AC.COMPANY = R.AC.REC<AC.AccountOpening.Account.CoCode>
    Y.TIME.STAMP = TIMEDATE()
   
*---------------Assigning to new Var------------------------------------------------*
    Y.CARD.STATUS = EB.SystemTables.getRNew(EB.ATM19.CARD.STATUS)
    Y.ATM.REQ.TYPE = EB.SystemTables.getRNew(EB.ATM19.REQUEST.TYPE)
    Y.ATM.ISS.TIME = EB.SystemTables.getRNew(EB.ATM19.ISSUE.TIME)
    Y.CARD.CLOSE.DATE = EB.SystemTables.getRNew(EB.ATM19.CARD.CLOSE.DATE)
    Y.ATM.ATTRIBUTE4 = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE4)
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.TODAY = EB.SystemTables.getToday()
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.IDCOMPANY = EB.SystemTables.getIdCompany()
*---------------Assigning to new Var---------------END---------------------------------*
    
    IF Y.CARD.STATUS EQ "PENDING" AND Y.ATM.REQ.TYPE EQ "ISSUE" AND Y.VFUNCTION EQ 'I' THEN
        EB.SystemTables.setRNew(EB.ATM19.ISSUE.TIME, Y.TIME.STAMP[1,2]:Y.TIME.STAMP[4,2])
    END
    IF Y.CARD.STATUS EQ "APPROVED" AND Y.ATM.REQ.TYPE EQ "CLOSE" AND Y.VFUNCTION EQ 'I' THEN
        EB.SystemTables.setRNew(EB.ATM19.APPROVED.DATE, Y.TODAY)
    END
    
    EB.SystemTables.setRNew(EB.ATM19.ACCT.CATEGORY, Y.CATEGORY)
    
    Y.REQUEST = "EB.JBL.ATM.CARD.MGT":Y.PGM.VERSION

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,REISSUE" AND Y.VFUNCTION EQ 'I' THEN
        EB.SystemTables.setRNew(EB.ATM19.REQUEST.TYPE, "REISSUE")
        EB.SystemTables.setRNew(EB.ATM19.CARD.STATUS, "PENDING")
        EB.SystemTables.setRNew(EB.ATM19.RE.ISSUE.TIME, Y.TIME.STAMP[1,2]:Y.TIME.STAMP[4,2])
        EB.SystemTables.setRNew(EB.ATM19.RE.ISSUE.DATE, Y.TODAY)

*---------------Assigning to new Var-------------------------------------*
        Y.REISSUE.REASON = EB.SystemTables.getRNew(EB.ATM19.REISSUE.REASON)
        Y.ISSUE.WAIVE.CHARGE = EB.SystemTables.getRNew(EB.ATM19.ISSUE.WAIVE.CHARGE)
        Y.NARR = EB.SystemTables.getRNew(EB.ATM19.NARRATIVE)
        Y.TO.DATE = EB.SystemTables.getRNew(EB.ATM19.TO.DATE)
        
        IF Y.REISSUE.REASON NE 5 AND Y.ISSUE.WAIVE.CHARGE EQ "YES" AND Y.NARR EQ "" THEN
            EB.SystemTables.setEtext("Please Provide Reissue Waive Reason")
            EB.ErrorProcessing.StoreEndError()
        END
    END

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,PINREQ" AND Y.VFUNCTION EQ 'I' THEN
        EB.SystemTables.setRNew(EB.ATM19.ATTRIBUTE3, Y.TODAY)
        EB.SystemTables.setRNew(EB.ATM19.REQUEST.TYPE, "PINREISSUE")
        EB.SystemTables.setRNew(EB.ATM19.CARD.STATUS, "PENDING")

        IF Y.ISSUE.WAIVE.CHARGE EQ "YES" AND Y.NARR EQ "" AND Y.REISSUE.REASON NE 7 THEN
            EB.SystemTables.setEtext("Please Provide Pin Reissue Waive Reason")
            EB.ErrorProcessing.StoreEndError()
        END
    END
    
    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSE" AND Y.VFUNCTION EQ 'I' THEN
        EB.SystemTables.setRNew(EB.ATM19.CARD.CLOSE.RE.DATE, Y.TODAY)
        EB.SystemTables.setRNew(EB.ATM19.REQUEST.TYPE, "CLOSE")
        EB.SystemTables.setRNew(EB.ATM19.CARD.STATUS, "PENDING")

        IF Y.ISSUE.WAIVE.CHARGE EQ "YES" AND Y.NARR EQ "" THEN
            EB.SystemTables.setEtext("Please Provide Card Close Waive Reason")
            EB.ErrorProcessing.StoreEndError()
        END
    END

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,WAIVE" AND Y.VFUNCTION EQ 'I' THEN
        EB.SystemTables.setRNew(EB.ATM19.REQUEST.TYPE, "WAIVE")
    END

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,WAIVE" AND Y.VFUNCTION EQ 'A' THEN
        EB.SystemTables.setRNew(EB.ATM19.CARD.STATUS, "DONE")
    END

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,ISSUE" AND Y.VFUNCTION EQ 'I' THEN
        EB.SystemTables.setRNew(EB.ATM19.CARD.STATUS, "PENDING")
    END

    Y.ID = EB.SystemTables.getIdNew()
    EB.DataAccess.FRead(FN.ATM,Y.ID,R.ATM.REC,F.ATM,Y.ERR)
    
    IF R.ATM.REC NE "" AND Y.VFUNCTION EQ 'I' THEN
        IF Y.CARD.STATUS EQ "DENIED" THEN
            R.ATM.REC<EB.ATM19.CARD.STATUS>=""
        END
        ELSE
            R.ATM.REC<EB.ATM19.CARD.STATUS>="PROCESSING"
        END
* CALL F.WRITE(FN.ATM,Y.ID,R.ATM.REC)
        EB.DataAccess.FWrite(FN.ATM, Y.ID, R.ATM.REC)
        EB.TransactionControl.JournalUpdate(Y.ID)
    END
    IF R.ATM.REC NE "" AND Y.VFUNCTION EQ 'D' AND ( Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,DENIED" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSEHO" OR  Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,PINHO") THEN
        R.ATM.REC<EB.ATM19.CARD.STATUS>="PENDING"
* CALL F.WRITE(FN.ATM,Y.ID,R.ATM.REC)
        EB.DataAccess.FWrite(FN.ATM, Y.ID, R.ATM.REC)
        EB.TransactionControl.JournalUpdate(Y.ID)
    END
    
    IF R.ATM.REC NE "" AND Y.VFUNCTION EQ 'D' AND ( Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,REISSUE" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSE" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,ISSUE" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,WAIVE" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,PINREQ") THEN
        IF Y.CARD.STATUS EQ "" THEN
            R.ATM.REC<EB.ATM19.CARD.STATUS>="DENIED"
        END
        ELSE
            R.ATM.REC<EB.ATM19.CARD.STATUS>="DONE"
        END
* CALL F.WRITE(FN.ATM,Y.ID,R.ATM.REC)
        EB.DataAccess.FWrite(FN.ATM, Y.ID, R.ATM.REC)
        EB.TransactionControl.JournalUpdate(Y.ID)
    END
    IF R.ATM.REC NE "" AND Y.VFUNCTION EQ 'D' AND ( Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,DELIVERY" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSEBR" ) THEN
        R.ATM.REC<EB.ATM19.CARD.STATUS>="APPROVED"
* CALL F.WRITE(FN.ATM,Y.ID,R.ATM.REC)
        EB.DataAccess.FWrite(FN.ATM, Y.ID, R.ATM.REC)
        EB.TransactionControl.JournalUpdate(Y.ID)
    END

    IF Y.VFUNCTION EQ 'I' THEN
        EB.SystemTables.setRNew(EB.ATM19.INPUTTER.CO.CODE, Y.IDCOMPANY)
    END

    IF Y.VFUNCTION EQ 'R' THEN
        EB.SystemTables.setEtext("REVERSE IS NOT ALLOWED")
        EB.ErrorProcessing.StoreEndError()
    END
*------------------------------BANK COMMENT -----------------------------------------------------------------*
    !IF ID.COMPANY NE "BD0012001" AND (Y.REQUEST  EQ "EB.JBL.ATM.CARD.MGT,UPDATE" OR Y.REQUEST EQ  "EB.JBL.ATM.CARD.MGT,CLOSEHO" OR Y.REQUEST EQ  "EB.JBL.ATM.CARD.MGT,DENIED" OR Y.REQUEST EQ  "EB.JBL.ATM.CARD.MGT,PINHO") THEN
    !ETEXT ="CARD PROCESSING ALLOW ONLY HEAD OFFICE"
    !CALL STORE.END.ERROR
    !END
    !IF ID.COMPANY NE Y.AC.COMPANY THEN
    !IF Y.REQUEST  EQ "EB.JBL.ATM.CARD.MGT,UPDATE" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSEHO" OR Y.REQUEST EQ  "EB.JBL.ATM.CARD.MGT,DENIED" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,PINHO" THEN

    !END
    !ELSE
    !ETEXT ="CARD INPUT GIVEN ONLY OWN BRANCH"
    !CALL STORE.END.ERROR
    !END
    !END
*-----------------------------------BANK COMMENT ----END-----------------------------------------------------*
    
    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" AND Y.VFUNCTION EQ 'I' AND Y.ATM.REQ.TYPE EQ "REISSUE" AND Y.CARD.CLOSE.DATE EQ "" AND Y.ATM.ATTRIBUTE4 EQ "" THEN
        EB.SystemTables.setEtext("Please Provide Reissue Date")
        EB.ErrorProcessing.StoreEndError()
    END
    
    IF Y.NARR NE "" AND LEN(Y.NARR) GT 80 THEN
        EB.SystemTables.setEtext("Narrative must be within 80 characters")
        EB.ErrorProcessing.StoreEndError()
    END
    
    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" AND Y.VFUNCTION EQ 'I' AND Y.ATM.REQ.TYPE NE "REISSUE" THEN
        EB.SystemTables.setT(EB.ATM19.ATTRIBUTE4, 'NOINPUT')
    END
    
    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE"  AND Y.VFUNCTION EQ 'I' AND Y.ATM.REQ.TYPE EQ "REISSUE" THEN
*        IF R.NEW(EB.ATM19.CARD.CLOSE.DATE) NE "" THEN
*            T(EB.ATM19.ATTRIBUTE4)<3> = 'NOINPUT'
*        END
        IF Y.CARD.CLOSE.DATE NE "" THEN
            EB.SystemTables.setT(EB.ATM19.ATTRIBUTE4, 'NOINPUT')
        END
*        ELSE IF R.NEW(EB.ATM19.CARD.CLOSE.DATE) EQ "" THEN
*            T(EB.ATM19.FROM.DATE)<3> = 'NOINPUT'
*        END
        ELSE IF Y.CARD.CLOSE.DATE EQ "" THEN
            EB.SystemTables.setT(EB.ATM19.FROM.DATE, 'NOINPUT')
        END
    END
    
    Y.ATTR5 = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE5)
   
*--------------------------- FT CHECK ----------------------------------------------*
    IF Y.VFUNCTION EQ 'D' AND Y.CARD.STATUS EQ "PENDING" AND Y.ATTR5 NE "" THEN
        EB.SystemTables.setRNew(EB.ATM19.ATTRIBUTE5, "")

        Y.ATM.CR.ID = Y.ATTR5
        EB.DataAccess.FRead(FN.FT.NAU, Y.ATM.CR.ID, REC.FT.CHK, F.FT.NAU, ERR.FT)
        Y.FT.CHK = REC.FT.CHK<FT.Contract.FundsTransfer.RecordStatus>

        IF REC.FT.CHK EQ "" THEN
            EB.DataAccess.FRead(FN.FT, Y.ATM.CR.ID, REC.FT.CHK, F.FT, ERR.FT.LIVE)
        END
        IF REC.FT.CHK EQ "" THEN
            EB.DataAccess.ReadHistoryRec(F.FT.HIS, Y.ATM.CR.ID, REC.FT.CHK, Y.ERR.FT.HIS)
        END
        IF REC.FT.CHK NE "" AND Y.FT.CHK EQ "REVE" THEN
        END
        ELSE IF REC.FT.CHK NE "" THEN
            EB.SystemTables.setEtext("FUNDS TRANSFER is at UNAUTHORISED STAGE or ALREADY DEDUCTED for this REQUEST")
            EB.ErrorProcessing.StoreEndError()
        END
    END
*--------------------------- FT CHECK ----------------- END ------------------------*
    
*------------ FT TXN isn't require as per new requirement -----------------------------*
*        Y.ATM.CR.ID = Y.ATTR5
*        TXNID = Y.ATTR5
*        TransactionId = "FT211058SHDZ"
** TXNID = TransactionId
*
*        OFS.SOURCE = "CARD.OFS"
*        KOfsSource1 = OFS.SOURCE
**---------------- REVERSE OFS --------*
*        OfsMessage = ""
*        Ofsrecord = ""
*        Y.DR.COM = Y.IDCOMPANY
** Y.MESSAGE = "FUNDS.TRANSFER,JBL.ATM.OFS.AC/R/PROCESS//0,INPUTT/123456/,FT21096158WB"
** EB.Interface.OfsCallBulkManager(OFS.SOURCE, Y.MESSAGE, OFS.RES, TXN.VAL)
*        EB.Foundation.OfsBuildRecord("FUNDS.TRANSFER", "D", "PROCESS", "FUNDS.TRANSFER,JBL.ATM.OFS.AC", "", 0, TransactionId, "", Ofsrecord)
*        EB.Interface.OfsGlobusManager(KOfsSource1, Ofsrecord)
*********--------------------------TRACER------------------------------------------------------------------------------
*        WriteData = "GB.JBL.I.ATM.ISSUE.UPDATE = Ofsrecord: ":Ofsrecord:" Y.VFUNCTION: ":Y.VFUNCTION:" Y.ATTR5: ":Y.ATTR5:" TransactionId: ":TransactionId
** WriteData = "GB.JBL.I.ATM.ISSUE.UPDATE = OFS.SOURCE: ":OFS.SOURCE:" OFS.RES: ":OFS.RES:" Y.VFUNCTION: ":Y.VFUNCTION:" Y.MESSAGE: ":Y.MESSAGE:" TransactionId: ":TransactionId
** WriteData = "GB.JBL.I.ATM.ISSUE.UPDATE = var_ofsMessage: ":var_ofsMessage:" Y.OFS.REQ.ERR: ":Y.OFS.REQ.ERR:" Y.VFUNCTION: ":Y.VFUNCTION:" Y.MESSAGE: ":Y.MESSAGE:" TransactionId: ":TransactionId
*        FileName = 'SHIBLI_ATM.txt'
*        FilePath = 'D:/Temenos/t24home/default/DL.BP'
*        OPENSEQ FilePath,FileName TO FileOutput THEN NULL
*        ELSE
*            CREATE FileOutput ELSE
*            END
*        END
*        WRITESEQ WriteData APPEND TO FileOutput ELSE
*            CLOSESEQ FileOutput
*        END
*        CLOSESEQ FileOutput
*********--------------------------TRACER-END--------------------------------------------------------*********************
*------------ FT TXN isn't require as per new requirement --- END --------------------------*

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,REISSUE" AND Y.VFUNCTION EQ 'I' AND Y.CARD.STATUS EQ "PENDING" AND Y.REISSUE.REASON EQ 5 THEN
        Y.DAYS = "C"
        EB.API.Cdd("", Y.TODAY, Y.TO.DATE, Y.DAYS)
        
        IF(Y.DAYS GE 30) THEN
            EB.SystemTables.setEtext("CARD VALIDATION " : Y.DAYS :" DAYS REMAINING")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
END
