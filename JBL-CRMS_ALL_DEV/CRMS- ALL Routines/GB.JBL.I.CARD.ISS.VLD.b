* @ValidationCode : Mjo1MzM4NTYwMDc6Q3AxMjUyOjE3MDQ3Nzg2NTcwMzk6bmF6aWhhcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:37:37
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
SUBROUTINE GB.JBL.I.CARD.ISS.VLD
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :02/01/2024
* Deploy Date: 12 JAN 2019
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: THIS ROUTINE IS USED FOR CRMS - REISSUE AND PIN-REISSUE REASON VALIDATION
* Subroutine Type: INPUT
* Attached To    : EB.JBL.ATM.CARD.MGT,REISSUE
* Attached As    : INPUT ROUTINE
* TAFC Routine Name : CARD.ISS.VLD - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    $USING EB.TransactionControl
    $USING EB.API
    $USING EB.LocalReferences
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.I.CARD.ISS.VLD Routine is found Successfully"
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

* Y.CARD.NAME=R.NEW(EB.ATM19.CARD.NAME)
    Y.CARD.NAME = EB.SystemTables.getRNew(EB.ATM19.CARD.NAME)
    Y.RES.REASON = 1:@FM:2:@FM:3:@FM:4:@FM:5
    Y.PIN.REASON = 1:@FM:2:@FM:6:@FM:7
* Y.REQUEST.TYPE=R.NEW(EB.ATM19.REQUEST.TYPE)
    Y.REQUEST.TYPE = EB.SystemTables.getRNew(EB.ATM19.REQUEST.TYPE)
* Y.REASON=R.NEW(EB.ATM19.REISSUE.REASON)
    Y.REASON = EB.SystemTables.getRNew(EB.ATM19.REISSUE.REASON)
    Y.COUNT = DCOUNT(Y.CARD.NAME," ")
    FOR I=1 TO Y.COUNT
        IF NOT(ALPHA(FIELD(Y.CARD.NAME," ",I))) THEN
*            ETEXT ="PLEASE REMOVE SPECIAL CHARACTER FROM CARD NAME"
            EB.SystemTables.setEtext("PLEASE REMOVE SPECIAL CHARACTER FROM CARD NAME")
*            CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
        END
    NEXT I

    Y.CATE.CHK=0


    IF Y.REQUEST.TYPE EQ "REISSUE" THEN
        Y.RES.COUNT=DCOUNT(Y.RES.REASON,@FM)
        FOR I=1 TO Y.RES.COUNT
            Y.CATE = FIELD(Y.RES.REASON,@FM,I)
            IF Y.CATE EQ Y.REASON THEN
                Y.CATE.CHK=1
                BREAK
            END
        NEXT I
    END

    IF Y.REQUEST.TYPE EQ "PINREISSUE" THEN
        Y.RES.COUNT=DCOUNT(Y.PIN.REASON,@FM)
        FOR I=1 TO Y.RES.COUNT
            Y.CATE = FIELD(Y.RES.REASON,@FM,I)
            IF Y.CATE EQ Y.REASON THEN
                Y.CATE.CHK=1
                BREAK
            END
        NEXT I
    END

    IF Y.CATE.CHK EQ 0 THEN
*        ETEXT ="Invalid Reason"
        EB.SystemTables.setEtext("Invalid Reason")
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
END
