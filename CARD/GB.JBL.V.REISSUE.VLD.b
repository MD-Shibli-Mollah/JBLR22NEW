* @ValidationCode : Mjo1OTk1OTc2OTY6Q3AxMjUyOjE3MDQ3Nzg3NTIwMTI6bmF6aWhhcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:39:12
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
SUBROUTINE GB.JBL.V.REISSUE.VLD
*-----------------------------------------------------------------------------
* Modification History :
* 1) *List of Closed deposit accounts for given period
* Date :31/12/2023
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for CRMS- NOINPUT Attribute4-FT RecId based on Request.
* Subroutine Type: Validation
* Attached To    : EB.JBL.ATM.CARD.MGT,UPDATE
* Attached As    : Validation ROUTINE
* TAFC Routine Name :JBL.REISSUE.VLD - R09
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.V.REISSUE.VLD Routine is found Successfully"
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
    Y.REQUEST.TYPE = EB.SystemTables.getRNew(EB.ATM19.REQUEST.TYPE)
    Y.CARD.CLOSE.DATE = EB.SystemTables.getRNew(EB.ATM19.CARD.CLOSE.DATE)

    Y.REQUEST = "EB.JBL.ATM.CARD.MGT":Y.PGM.VERSION
    
    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" AND Y.VFUNCTION EQ 'I' AND Y.REQUEST.TYPE EQ "ISSUE" THEN
* T(EB.ATM19.ATTRIBUTE4)<3> = 'NOINPUT'
        EB.SystemTables.setT(EB.ATM19.ATTRIBUTE4, 'NOINPUT')
    END

    IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" AND Y.VFUNCTION EQ 'I' AND Y.REQUEST.TYPE EQ "REISSUE" THEN
        IF Y.CARD.CLOSE.DATE NE "" THEN
            !R.NEW(EB.ATM19.FROM.DATE)=""
* T(EB.ATM19.ATTRIBUTE4)<3> = 'NOINPUT'
            EB.SystemTables.setT(EB.ATM19.ATTRIBUTE4, 'NOINPUT')
        END
        ELSE IF Y.CARD.CLOSE.DATE EQ "" THEN
* T(EB.ATM19.FROM.DATE)<3> = 'NOINPUT'
            EB.SystemTables.setT(EB.ATM19.FROM.DATE, 'NOINPUT')
            !R.NEW(EB.ATM19.ATTRIBUTE4) =""

        END
    END
RETURN
END
