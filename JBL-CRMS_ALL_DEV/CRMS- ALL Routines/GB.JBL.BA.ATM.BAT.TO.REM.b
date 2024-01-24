* @ValidationCode : MjotMTAwOTU1MzY0NTpDcDEyNTI6MTcwNDc3NjA1MTA2NjpuYXppaGFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 10:54:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE GB.JBL.BA.ATM.BAT.TO.REM
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :08/01/2024
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for CRMS ISSUE VERSION CUSTOMER INFO SHOW
* Subroutine Type: BEFORE AUTH
* Attached To    : EB.JBL.ATM.CARD.MGT,UPDATE
* Attached As    : BEFORE AUTH ROUTINE
* TAFC Routine Name : JBL.ATM.BAT.TO.REM - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.JBL.CARD.BATCH.CRE
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.TransactionControl
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.BA.ATM.BAT.TO.REM Routine is found Successfully"
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

    FN.BATCH1 = "F.EB.JBL.CARD.BATCH.CRE"
    F.BATCH1 = ""
    EB.DataAccess.Opf(FN.BATCH1, F.BATCH1)
    
    Y.ATTRIBUTE1 = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE1)
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.REQUEST.TYPE = EB.SystemTables.getRNew(EB.ATM19.REQUEST.TYPE)

    IF Y.ATTRIBUTE1 NE "" AND Y.VFUNCTION EQ 'A' AND Y.REQUEST.TYPE EQ "REISSUE" THEN

* Y.BATCH.NO=R.NEW(EB.ATM19.ATTRIBUTE1)
        Y.BATCH.NO = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE1)
        
        EB.DataAccess.FRead(FN.BATCH1, Y.BATCH.NO, R.BATCH, F.BATCH1, ERR1)
        Y.PENDING = R.BATCH<EB.CARD.BAT.PENDING.CARD>

        IF Y.PENDING NE 0 THEN
            Y.PENDING = Y.PENDING - 1
            R.BATCH<EB.CARD.BAT.PENDING.CARD>= Y.PENDING
            EB.DataAccess.FWrite(FN.BATCH1, Y.BATCH.NO, R.BATCH)
            EB.TransactionControl.JournalUpdate(Y.BATCH.NO)

        END
        !CALL F.RELEASE(FN.BATCH1,Y.BATCH.NO,F.BATCH1)
    END
RETURN
END

