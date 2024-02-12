* @ValidationCode : MjotNDM4NDM4MjI5OkNwMTI1MjoxNzA0NzgxMTg2MDM1Om5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 12:19:46
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
SUBROUTINE GB.JBL.CARD.BATCH.CRE.CHECKID
*-----------------------------------------------------------------------------
* Modification History : RETROFIT from TAFC to TAFJ
* 1)
* Date :01/01/2024
* Modification Description :
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for EB.JBL.CARD.BATCH.CRE
* Subroutine Type: CHECKID
* Attached To    : EB.TABLE.PROCEDURES
* Attached As    : CHECKID
* TAFC Routine Name : JBL.CARD.BATCH.CRE.ID - R09
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT GLOBUS.BP I_Table
    $INSERT I_F.EB.JBL.CARD.BATCH.CRE
    $USING EB.SystemTables
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "EB.JBL.CARD.BATCH.CRE.CHECKID Routine is found Successfully"
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
    
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.TIMEDATE = EB.SystemTables.getTimeStamp() ;*TIMEDATE()
*    Y.COMI = EB.SystemTables.getComi()
*    Y.ID.NEW = EB.SystemTables.getIdNew()

    Y.REQUEST = "EB.JBL.CARD.BATCH.CRE":Y.PGM.VERSION

    IF Y.VFUNCTION EQ "I" AND Y.REQUEST NE "EB.JBL.CARD.BATCH.CRE,BATREM" THEN
        DATE.STAMP = OCONV(DATE(), 'D4-')
* Y.TIMEDATE = TIMEDATE()

        Y.DATE.TIME = "BA":DATE.STAMP[7,4]:DATE.STAMP[1,2]:DATE.STAMP[4,2]: Y.TIMEDATE[1,2]:Y.TIMEDATE[4,2]::Y.TIMEDATE[7,2]
        Y.COMI = Y.DATE.TIME
* ID.NEW=Y.DATE.TIME
        EB.SystemTables.setComi(Y.DATE.TIME)
        EB.SystemTables.setIdNew(Y.DATE.TIME)
    END
RETURN
END
