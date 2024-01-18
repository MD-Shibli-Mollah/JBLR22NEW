* @ValidationCode : MjotMTQyNTg1MjUyMzpDcDEyNTI6MTcwNDc5NDcwNTk2NjpuYXppaGFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 16:05:05
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
SUBROUTINE GB.JBL.E.NOF.ATM.BAT.TO.CSV(Y.RETURN)
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :08/01/2024
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for CRMS
* Subroutine Type: NOFILE
* Attached To    : NOFILE.JBL.SS.ATM.BAT.TO.CSV
* Attached As    : NOF ENQUIRY ROUTINE
* TAFC Routine Name :JBL.ATM.BAT.TO.CSV - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.JBL.CARD.BATCH.CRE
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    
    $USING EB.Reports
    $USING EB.DataAccess
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.E.NOF.ATM.BAT.TO.CSV Routine is found Successfully"
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
    
    FN.BATCH = "F.EB.JBL.CARD.BATCH.CRE"
    F.BATCH = ""
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ""

    EB.DataAccess.Opf(FN.BATCH, F.BATCH)
    EB.DataAccess.Opf(FN.ATM, F.ATM)

    LOCATE "ATTRIBUTE1" IN EB.Reports.getEnqSelection()<2,1> SETTING REC.POS THEN
        Y.BATCH.NO = EB.Reports.getEnqSelection()<4,REC.POS>
    END

    !Y.BATCH.NO="BA20190120112842"

    EB.DataAccess.FRead(FN.BATCH, Y.BATCH.NO, R.BATCH, F.BATCH, ERR1)
    Y.REQUEST.IDS = R.BATCH<EB.CARD.BAT.REQUEST.ID>
    Y.BAT.REQUEST.TYPE = R.BATCH<EB.CARD.BAT.REQUEST.TYPE>

    Y.COUNT = DCOUNT(Y.REQUEST.IDS, @VM)
    FOR I=1 TO Y.COUNT
        Y.RESULT = Y.REQUEST.IDS<1,I>
        EB.DataAccess.FRead(FN.ATM, Y.RESULT, R.CARD, F.ATM, ERR2)
        Y.CARD.STATUS = R.CARD<EB.ATM19.CARD.STATUS>
        Y.REQUEST.TYPE = R.CARD<EB.ATM19.REQUEST.TYPE>
        
        IF Y.CARD.STATUS EQ "PENDING" AND Y.BAT.REQUEST.TYPE EQ Y.REQUEST.TYPE THEN
            Y.RETURN<-1>= Y.RESULT
        END
    NEXT I

RETURN
END
