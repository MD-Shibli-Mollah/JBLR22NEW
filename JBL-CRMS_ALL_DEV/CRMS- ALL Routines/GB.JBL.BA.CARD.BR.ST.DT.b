* @ValidationCode : MjoxNjY0ODAxNTIzOkNwMTI1MjoxNzA0Nzc2MjU2NzcwOm5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 10:57:36
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
* Description : AUTO INPUT BRANCH CODE, STATUS AND ENTRY DATE
* Author      : AVIJIT SAHA
* Date        : 21.12.2021
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.BA.CARD.BR.ST.DT
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :08/01/2024
* Modification Description :  RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* Subroutine Description: This Routine Sets Card Type, Branch Code, Entry Date.
* Subroutine Type: BEFORE AUTH
* Attached To    : EB.JBL.CARD.BATCH.INFO,CARDINFO
* Attached As    : BEFORE AUTH ROUTINE
* TAFC Routine Name : JBL.CARD.BR.ST.DT - R09
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.CARD.BATCH.INFO
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    $USING EB.TransactionControl
    $USING EB.API
    $USING EB.LocalReferences
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.BA.CARD.BR.ST.DT Routine is found Successfully"
    FileName = 'SHIBLI_ATM.txt'
    FilePath = 'D:/Temenos/t24home/default/DL.BP'
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

    FN.ACCT  = "F.ACCOUNT"
    F.ACCT   = ''
    ACC.REC = ''
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ''
    ATM.REC = ''
    
* Y.T24.AC = ID.NEW
    Y.T24.AC = EB.SystemTables.getIdNew()
    Y.TODAY = EB.SystemTables.getToday()

    EB.DataAccess.Opf(FN.ACCT, F.ACCT)
    EB.DataAccess.Opf(FN.ATM, F.ATM)

    EB.DataAccess.FRead(FN.ACCT, Y.T24.AC, ACC.REC, F.ACCT, ERR)
    Y.CO.CODE = ACC.REC<AC.AccountOpening.Account.CoCode>
    
    IF ACC.REC NE '' THEN
        EB.LocalReferences.GetLocRef('ACCOUNT', 'LT.AC.ATM.CARD.NUM', Y.AC.ATM.CARD.NUM)
        Y.ATM.ID = ACC.REC<AC.AccountOpening.Account.LocalRef, Y.AC.ATM.CARD.NUM>

        !IF Y.ATM.ID NE '' THEN
        EB.DataAccess.FRead(FN.ATM, Y.ATM.ID, ATM.REC, F.ATM, ERR)
        Y.CARD.TYPE = ATM.REC<EB.ATM19.CARD.TYPE>

        EB.SystemTables.setRNew(EB.JBCARD.INFO.BRANCH.CODE, Y.CO.CODE)
*        R.NEW(JBCARD.INFO.STATUS) = "PENDING"
        EB.SystemTables.setRNew(EB.JBCARD.INFO.STATUS, "PENDING")
*        R.NEW(JBCARD.INFO.ENTRY.DATE) = TODAY
        EB.SystemTables.setRNew(EB.JBCARD.INFO.ENTRY.DATE, Y.TODAY)
        
        IF Y.ATM.ID NE '' THEN
*            R.NEW(JBCARD.INFO.CARD.TYPE) =  ATM.REC<EB.ATM19.CARD.TYPE>
            EB.SystemTables.setRNew(EB.JBCARD.INFO.CARD.TYPE, Y.CARD.TYPE)
*            R.NEW(JBCARD.INFO.REQ.REF.NO) = Y.ATM.ID
            EB.SystemTables.setRNew(EB.JBCARD.INFO.REQ.REF.NO, Y.ATM.ID)
        END
    END
RETURN
END

