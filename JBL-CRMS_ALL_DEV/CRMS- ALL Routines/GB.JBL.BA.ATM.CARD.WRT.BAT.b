* @ValidationCode : MjotMTM0OTQzMzk2MjpDcDEyNTI6MTcwNDc3NjE2MjAyODpuYXppaGFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 10:56:02
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
SUBROUTINE GB.JBL.BA.ATM.CARD.WRT.BAT
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :08/01/2024
* Modification Description :  RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* Subroutine Description: THIS ROUTINE IS USED FOR CRMS
* Subroutine Type: BEFORE AUTH
* Attached To    : EB.JBL.CARD.BATCH.CRE,INPUT
* Attached As    : BEFORE AUTH ROUTINE
* TAFC Routine Name : JBL.ATM.CARD.WRT.BAT - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.JBL.CARD.BATCH.CRE
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.TransactionControl
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.BA.ATM.CARD.WRT.BAT Routine is found Successfully"
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

    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ""
    FN.BAT.NAU = "F.EB.JBL.CARD.BATCH.CRE$NAU"
    F.BAT.NAU = ""

    EB.DataAccess.Opf(FN.ATM,F.ATM)
    EB.DataAccess.Opf(FN.BAT.NAU,F.BAT.NAU)

* Y.BATCH.ID=R.NEW(EB.ATM19.ATTRIBUTE1)
    Y.BATCH.ID = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE1)

* Y.REQ.ID=ID.NEW
    Y.REQ.ID = EB.SystemTables.getIdNew()

    EB.DataAccess.FRead(FN.BAT.NAU, Y.BATCH.ID, REC.BATCH, F.BAT.NAU, ERR.BATCH)
    Y.BAT.REQUEST.ID = REC.BATCH<EB.CARD.BAT.REQUEST.ID>
    IF DCOUNT(Y.BAT.REQUEST.ID, @VM) EQ 0 THEN
        REC.BATCH<EB.CARD.BAT.REQUEST.ID>= Y.REQ.ID
    END
    ELSE
        REC.BATCH<EB.CARD.BAT.REQUEST.ID>= REC.BATCH<EB.CARD.BAT.REQUEST.ID>:@VM:Y.REQ.ID
    END
    !WRITE REC.BATCH TO F.CHQ.BATCH,Y.BATCH.ID
* CALL F.WRITE(FN.BAT.NAU,Y.BATCH.ID,REC.BATCH)
    EB.DataAccess.FWrite(FN.BAT.NAU, Y.BATCH.ID, REC.BATCH)
    EB.TransactionControl.JournalUpdate(Y.BATCH.ID)

RETURN
END
