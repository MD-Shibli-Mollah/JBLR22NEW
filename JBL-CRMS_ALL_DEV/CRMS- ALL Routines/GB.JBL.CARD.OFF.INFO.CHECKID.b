* @ValidationCode : Mjo5OTA3NjIwNjpDcDEyNTI6MTcwNDc4MjU1MTAxNDpuYXppaGFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 12:42:31
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
SUBROUTINE GB.JBL.CARD.OFF.INFO.CHECKID
*-----------------------------------------------------------------------------
* Modification History : RETROFIT from TAFC to TAFJ
* 1)
* Date :01/01/2024
* Modification Description :
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for EB.JBL.CARD.OFF.INFO
* Subroutine Type: CHECKID
* Attached To    : EB.TABLE.PROCEDURES
* Attached As    : CHECKID
* TAFC Routine Name : JBL.CARD.OFF.INFO.ID - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
    $INCLUDE I_F.EB.JBL.CARD.OFF.INFO
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "EB.JBL.CARD.OFF.INFO.CHECKID Routine is found Successfully"
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

    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    
    EB.DataAccess.Opf(FN.ACC, F.ACC)
*Y.AC.ID = COMI
    Y.AC.ID = EB.SystemTables.getComi()
    
    EB.DataAccess.FRead(FN.ACC, Y.AC.ID, REC.ACC, F.ACC, ERR.ACC)
*    Y.CATEGORY=REC.ACC<AC.CATEGORY>
    Y.CATEGORY = REC.ACC<AC.AccountOpening.Account.Category>
*    Y.CO.CODE=REC.ACC<AC.CO.CODE>
    Y.CO.CODE = REC.ACC<AC.AccountOpening.Account.CoCode>
    
    IF Y.CATEGORY EQ 6001 OR Y.CATEGORY EQ 1001 OR Y.CATEGORY EQ 6019 THEN
        RETURN
    END

    ELSE
*        E="INVALID CATEGORY " :Y.CATEGORY
        EB.SystemTables.setE("INVALID CATEGORY " :Y.CATEGORY)
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()

    END

    IF Y.CO.CODE NE 'BD0010033' THEN
*        E="Your Branch are not allow "
        EB.SystemTables.setE("Your Branch is not allowed")
*        CALL STORE.END.ERROR
        EB.ErrorProcessing.StoreEndError()
    END

RETURN
END

