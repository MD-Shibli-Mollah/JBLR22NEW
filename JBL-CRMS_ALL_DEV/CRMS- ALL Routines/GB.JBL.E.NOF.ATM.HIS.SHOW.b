* @ValidationCode : MjotMTAxNjQ0ODg4NjpDcDEyNTI6MTcwNDc3NzgyNDUwNDpuYXppaGFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:23:44
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
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* THIS ROUTINE USE FOR DISPLAY CARD PROCESSING ENQUIRY
* Developed By: Md. Robiul Islam
*Deploy Date: 12 JAN 2017
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.E.NOF.ATM.HIS.SHOW(Y.LIST)
        
* Modification History :
* 1) *List of ATM HISTORY
* Date :31/12/2023
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for CRMS
* Subroutine Type: NOFILE
* Attached To    : NOFILE.JBL.SS.ATM.HIS.SHOW
* Attached As    : NOF ENQUIRY ROUTINE
* TAFC Routine Name : ATM.HIS.SHOW - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
* $INSERT GLOBUS.BP I_F.CUSTOMER
    $USING ST.Customer
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.LocalReferences
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.E.NOF.ATM.HIS.SHOW Routine is found Successfully"
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

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS


INIT:
    FN.ATM.HIS = "F.EB.JBL.ATM.CARD.MGT$HIS"
    F.ATM.HIS = ""
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ""
    FN.ATM.NAU = "F.EB.JBL.ATM.CARD.MGT$NAU"
    F.ATM.NAU = ""
    SEL.LIST = ""
    ACCT.TITLE = ""
    
OPENFILES:
    EB.DataAccess.Opf(FN.ATM, F.ATM)
    EB.DataAccess.Opf(FN.ATM.HIS, F.ATM.HIS)
    EB.DataAccess.Opf(FN.ATM.NAU, F.ATM.NAU)

    LOCATE "REC.ID" IN EB.Reports.getEnqSelection()<2,1> SETTING REC.POS THEN
        Y.ATM.REF = EB.Reports.getEnqSelection()<4,REC.POS>
    END

RETURN

PROCESS:

    SEL.CMD = "SELECT ":FN.ATM.HIS:" WITH @ID LIKE ":Y.ATM.REF:"..."
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    Y.COUNT = DCOUNT(SEL.LIST, @FM)
    
    FOR I=1 TO Y.COUNT
        Y.ATM.ID = Y.ATM.REF:";":I
        EB.DataAccess.FRead(FN.ATM.HIS, Y.ATM.ID, R.ATM, F.ATM.HIS, ERR1)
        GOSUB DOPROCESS
    NEXT I

    SEL.CMD = "SELECT ":FN.ATM:" WITH @ID EQ ":Y.ATM.REF
    EB.DataAccess.FRead(SEL.CMD, SEL.LIST.ATM, '', NO.OF.REC, RET.CODE)
    LOOP
        REMOVE Y.ATM.ID FROM SEL.LIST.ATM SETTING POS1
    WHILE Y.ATM.ID:POS1
        EB.DataAccess.FRead(FN.ATM,Y.ATM.ID,R.ATM,F.ATM,ERR1)
        GOSUB DOPROCESS
    REPEAT
RETURN

DOPROCESS:
    ATM.AC.NO = R.ATM<EB.ATM19.ACCT.NO>
    ATM.CARD.NO = R.ATM<EB.ATM19.CARD.NO>
    ATM.REQUEST.TYPE = R.ATM<EB.ATM19.REQUEST.TYPE>
    ATM.REISSUE.REASON = R.ATM<EB.ATM19.REISSUE.REASON>
    ATM.FROM.DATE = R.ATM<EB.ATM19.FROM.DATE>
    ATM.INPUTTER.CO.CODE = R.ATM<EB.ATM19.INPUTTER.CO.CODE>
    ATM.ISSUE.DATE = R.ATM<EB.ATM19.ISSUE.DATE>
    ATM.APPROVED.DATE = R.ATM<EB.ATM19.APPROVED.DATE>
    ATM.RE.ISSUE.DATE = R.ATM<EB.ATM19.RE.ISSUE.DATE>
    ATM.CARD.CLOSE.DATE = R.ATM<EB.ATM19.CARD.CLOSE.DATE>
    ATM.CARD.CLOSE.REASON = R.ATM<EB.ATM19.CARD.CLOSE.REASON>
    ATM.CHARGE.CODE = R.ATM<EB.ATM19.CHARGE.CODE>
    ATM.ATTRIBUTE2 = R.ATM<EB.ATM19.ATTRIBUTE2>
    ATM.ATTRIBUTE4 = R.ATM<EB.ATM19.ATTRIBUTE4>
    ATM.OVERRIDE = R.ATM<EB.ATM19.OVERRIDE>
    ATM.CURR.NO = R.ATM<EB.ATM19.CURR.NO>
    ATM.DATE.TIME = R.ATM<EB.ATM19.DATE.TIME>
    ATM.CO.CODE = R.ATM<EB.ATM19.CO.CODE>
    ATM.AUDITOR.CODE = R.ATM<EB.ATM19.AUDITOR.CODE>
    ATM.CARD.NAME = R.ATM<EB.ATM19.CARD.NAME>
    ATM.CARD.TYPE = R.ATM<EB.ATM19.CARD.TYPE>
    ATM.TO.DATE = R.ATM<EB.ATM19.TO.DATE>
    ATM.NARRATIVE = R.ATM<EB.ATM19.NARRATIVE>
    ATM.DELIVERY.DATE = R.ATM<EB.ATM19.DELIVERY.DATE>
    ATM.WAIVE.CHARGE = R.ATM<EB.ATM19.WAIVE.CHARGE>
    ATM.INPUTTER = R.ATM<EB.ATM19.INPUTTER>
    ATM.AUTHORISER = R.ATM<EB.ATM19.AUTHORISER>

    Y.LIST<-1>= ATM.AC.NO:'|':ACCT.TITLE:'|':ATM.CARD.NAME:'|':ATM.CARD.NO:'|':ATM.CARD.TYPE:'|':ATM.FROM.DATE:'|':ATM.TO.DATE:'|':ATM.NARRATIVE:'|':ATM.ISSUE.DATE:'|':ATM.RE.ISSUE.DATE:'|':ATM.APPROVED.DATE:'|':ATM.DELIVERY.DATE:'|':ATM.CARD.CLOSE.DATE:'|':ATM.CHARGE.CODE:'|':ATM.WAIVE.CHARGE:'|':ATM.INPUTTER:'|':ATM.AUTHORISER :"|": ATM.REQUEST.TYPE

RETURN
END

 