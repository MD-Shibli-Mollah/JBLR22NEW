* @ValidationCode : MjotMTk3MDkzMDkxODpDcDEyNTI6MTcwNDc4NzE2MDIwNDpuYXppaGFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 13:59:20
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
SUBROUTINE EB.JBL.ATM.MAINT.CALC.CHECKID
*-----------------------------------------------------------------------------
* Modification History : RETROFIT from TAFC to TAFJ
* 1)
* Date :01/01/2024
* Modification Description :
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for EB.JBL.ATM.MAINT.CALC
* Subroutine Type: CHECKID
* Attached To    : EB.TABLE.PROCEDURES
* Attached As    : CHECKID
* TAFC Routine Name : JBL.ATM.MAINT.CALC.ID - R09
*-----------------------------------------------------------------------------

*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "EB.JBL.ATM.MAINT.CALC.CHECKID Routine is found Successfully"
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

    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT I_Table
* $INCLUDE BP I_F.JBL.ATM.MAINT.CALC
    $INSERT I_F.EB.JBL.ATM.MAINT.CALC
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

    Y.ID.NEW = EB.SystemTables.getIdNew()
* Y.ID.NEW = EB.SystemTables.getComi()
 
    IF Y.ID.NEW EQ 'SYSTEM' OR Y.ID.NEW EQ 'ISSUE' OR Y.ID.NEW EQ 'REISSUE' OR Y.ID.NEW EQ 'CLOSE' OR Y.ID.NEW EQ 'PINREISSUE' THEN
        RETURN
    END
    
    ELSE
* E = "INVALID ID"
        EB.SystemTables.setE("INVALID ID")
        EB.ErrorProcessing.StoreEndError()
    END
*    IF E THEN
*        T.SEQU = "IFLD"
*        CALL ERR
*    END

RETURN
END
