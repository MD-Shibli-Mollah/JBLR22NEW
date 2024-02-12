* @ValidationCode : MjozMjA1Mzg2MTE6Q3AxMjUyOjE3MDQ3NzgxMzAyMTc6bmF6aWhhcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:28:50
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
SUBROUTINE GB.JBL.I.ATM.CARD.WRT.AUTH
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :08/01/2024
* Modification Description :  RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This Routine Checks the ID
* Subroutine Type: INPUT
* Attached To    : EB.JBL.CARD.BATCH.CRE,INPUT
* Attached As    : INPUT ROUTINE
* TAFC Routine Name : JBL.ATM.CARD.WRT.AUTH - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.JBL.CARD.BATCH.CRE
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.TransactionControl
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.I.ATM.CARD.WRT.AUTH Routine is found Successfully"
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

    Y.VFUNCTION = EB.SystemTables.getVFunction()

    EB.DataAccess.Opf(FN.ATM, F.ATM)

* Y.IDS=R.NEW(CARD.BAT.REQUEST.ID)
    Y.IDS = EB.SystemTables.getRNew(EB.CARD.BAT.REQUEST.ID)

    IF Y.IDS EQ "" AND Y.VFUNCTION EQ "A" THEN
*        ETEXT="REQUEST ID MISSING"
        EB.SystemTables.setEtext("REQUEST ID MISSING")
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
    END

    IF Y.IDS NE "" AND Y.VFUNCTION EQ "A" THEN
        Y.R.COUNT = DCOUNT(Y.IDS, @VM)
        EB.SystemTables.setRNew(EB.CARD.BAT.PENDING.CARD, Y.R.COUNT)
    END

    IF Y.VFUNCTION EQ "D" AND Y.IDS NE "" THEN
        LOOP
            REMOVE Y.ID FROM Y.IDS SETTING POS
        WHILE Y.ID:POS
            EB.DataAccess.FRead(FN.ATM, Y.ID, REC.ATM, F.ATM, ERR.ATM)
            REC.ATM<EB.ATM19.ATTRIBUTE1>= ""
* CALL F.WRITE(FN.ATM,Y.ID,REC.ATM)
            EB.DataAccess.FWrite(FN.ATM, Y.ID, REC.ATM)
            EB.TransactionControl.JournalUpdate(Y.ID)
        REPEAT
    END
RETURN
END

