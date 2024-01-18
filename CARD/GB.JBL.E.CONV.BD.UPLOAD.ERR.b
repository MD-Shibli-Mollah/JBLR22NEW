* @ValidationCode : MjoyMDc4NDczNzMwOkNwMTI1MjoxNzA0Nzc3Mjc5MzA2Om5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:14:39
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
SUBROUTINE GB.JBL.E.CONV.BD.UPLOAD.ERR
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History : RETROFIT from TAFC to TAFJ
* 1)
* Date :08/01/2024
* Modification Description :
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for ATM CARD MANAGEMENT SYSTEM
* Subroutine Type: Conversion
* Attached To    : JBL.ENQ.UPLOAD.ERR.DETAIL
* Attached As    : CONVERSION ROUTINE
* TAFC Routine Name : E.CONV.BD.UPLOAD.ERR - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
* $INSERT ../T24_BP I_F.EB.LOGGING
    $USING EB.Logging
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.E.CONV.BD.UPLOAD.ERR Routine is found Successfully"
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
*
    FN.LOGGING = 'F.EB.LOGGING'
    F.LOGGING = ''
    EB.DataAccess.Opf(FN.LOGGING, F.LOGGING)

* Y.ID = O.DATA
    Y.ID = EB.Reports.getOData()
        
    EB.DataAccess.FRead(FN.LOGGING, Y.ID, R.LOGGING, F.LOGGING, ERR)
* Y.DET = R.LOGGING<EB.LOG.LOG.DETAILS>
    Y.DET = R.LOGGING<EB.Logging.EbLogMsgDetails>
    
    Y.UPD.DET1 = FIELDS(Y.DET,'|',1)
    Y.UPD.DET2 = FIELDS(Y.DET,'|',2)
        
    IF Y.UPD.DET2 THEN
* O.DATA = Y.UPD.DET2
        EB.Reports.setOData(Y.UPD.DET2)
    END ELSE
* O.DATA = Y.UPD.DET1
        EB.Reports.setOData(Y.UPD.DET1)
    END
RETURN
END

