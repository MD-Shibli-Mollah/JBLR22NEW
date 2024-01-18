* @ValidationCode : MjoxMjU1MDM4MzAzOkNwMTI1MjoxNzA0Nzc2NDUzNTcwOm5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:00:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
*-----
* Description : CHANGE STATUS FROM "PENDING" TO "DONE"
* Author      : AVIJIT SAHA
* Date        : 21.12.2021
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.BA.CARD.UP.ST.CHNG
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :08/01/2024
* Modification Description :  RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* Subroutine Description: THIS ROUTINE IS USED FOR CRMS -CHECK FT BEFORE AUTHRISED THE REQUEST
* Subroutine Type: BEFORE AUTH
* Attached To    : EB.JBL.ATM.CARD.MGT,UPDATE
* Attached As    : BEFORE AUTH ROUTINE
* TAFC Routine Name : JBL.CARD.UP.ST.CHNG - R09
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT GLOBUS.BP I_F.ACCOUNT
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
    WriteData = "GB.JBL.BA.CARD.UP.ST.CHNG Routine is found Successfully"
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

    FN.CARD = "F.EB.JBL.CARD.BATCH.INFO"
    F.CARD = ''
    
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.ACCT.NO = EB.SystemTables.getRNew(EB.ATM19.ACCT.NO)
    
    Y.REQUEST = "EB.JBL.ATM.CARD.MGT":Y.PGM.VERSION

    EB.DataAccess.Opf(FN.CARD, F.CARD)

    EB.DataAccess.FRead(FN.CARD, Y.ACCT.NO, R.CARD, F.CARD, ERR)
    Y.INFO.STATUS = R.CARD<EB.JBCARD.INFO.STATUS>

    IF R.CARD NE '' AND Y.INFO.STATUS EQ "PENDING" THEN

        R.CARD<EB.JBCARD.INFO.STATUS>= "DONE"
* CALL F.WRITE(FN.CARD,R.NEW(EB.ATM19.ACCT.NO),R.CARD)
        EB.DataAccess.FWrite(FN.CARD, Y.ACCT.NO, R.CARD)
    END
RETURN
END

