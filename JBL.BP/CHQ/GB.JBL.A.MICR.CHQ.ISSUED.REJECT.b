* @ValidationCode : Mjo1MzYzMDI3OkNwMTI1MjoxNjYwNjQ4NDk3ODY5Om5hemliOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Aug 2022 17:14:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

SUBROUTINE GB.JBL.A.MICR.CHQ.ISSUED.REJECT
*
*Retrofitted By:
*    Date         : 14/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.CHEQUE.ISSUE
    $INSERT  I_F.EB.JBL.MICR.MGT

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING CQ.ChqIssue

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

INIT:

    FN.CHQ.ISS = 'F.CHEQUE.ISSUE'
    F.CHQ.ISS = ''

    FN.CHQ.ISS.NAU = 'F.CHEQUE.ISSUE$NAU'
    F.CHQ.ISS.NAU = ''

    FN.CHQ.ISS.HIS='F.CHEQUE.ISSUE$HIS'
    F.CHQ.ISS.HIS=''

    FN.MICR.ISS='FBNK.EB.JBL.MICR.MGT'
    F.MICR.ISS=''
*
RETURN

OPENFILES:
    EB.DataAccess.Opf(FN.CHQ.ISS,F.CHQ.ISS)
    EB.DataAccess.Opf(FN.CHQ.ISS.NAU,F.CHQ.ISS.NAU)
    EB.DataAccess.Opf(FN.CHQ.ISS.HIS,F.CHQ.ISS.HIS)
    EB.DataAccess.Opf(FN.MICR.ISS,F.MICR.ISS)

RETURN
*-------
PROCESS:
*-------
    IF EB.SystemTables.getVFunction() EQ "A" THEN
        !  DEBUG
        Y.CHQ.ID = EB.SystemTables.getIdNew()
        EB.DataAccess.FRead(FN.MICR.ISS,Y.CHQ.ID,REC.MICR,F.MICR.ISS,ERR)
        Y.CHQ.TYPE = REC.MICR<EB.JBL82.CHQ.TYPE>
        !FIELD(ID.NEW,".",1)
        Y.T24.AC = REC.MICR<EB.JBL82.ACCOUNT>
        !FIELD(ID.NEW,".",2)
        Y.STARTING.NO = REC.MICR<EB.JBL82.STARTING.NO>
        Y.NUMBER.ISSUED = REC.MICR<EB.JBL82.NO.OF.BOOK> * REC.MICR<EB.JBL82.LEAF.TYPE>

        Y.MICR.ID = Y.CHQ.TYPE:".":Y.T24.AC

*-------List of Issued Checked from Live Table -------------*

        SEL.CMD = "SELECT ":FN.CHQ.ISS: " WITH @ID LIKE '":Y.MICR.ID:"...'"
        EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
        Y.SEQ = FIELDS(SEL.LIST<NO.OF.REC>, ".",3)

*-------List of Issued Checked from UnAuth Table -------------*

        SEL.CMD.NAU = "SELECT ":FN.CHQ.ISS.NAU: " WITH @ID LIKE '":Y.MICR.ID:"...'"
        EB.DataAccess.Readlist(SEL.CMD.NAU,SEL.LIST.NAU,'',NO.OF.REC.NAU,RET.CODE.NAU)
        Y.SEQ.NAU = FIELDS(SEL.LIST.NAU<NO.OF.REC.NAU>, ".",3)

        IF Y.SEQ.NAU NE "" AND Y.SEQ.NAU > Y.SEQ THEN
            Y.TEMP.SEQ =  FMT((Y.SEQ.NAU + 1), 'R0%7')
        END
        ELSE
            Y.TEMP.SEQ =  FMT((Y.SEQ + 1), 'R0%7')
        END
        Y.RECORD.ID = Y.MICR.ID:".":Y.TEMP.SEQ

*-------Check Maximum Sequence Number from History Table -------------*
        EB.DataAccess.FReadHistory(FN.CHQ.ISS.HIS,Y.RECORD.ID,R.HIS,F.CHQ.ISS.HIS,ERR)
        IF R.HIS NE "" THEN
            Y.NEW.SEQ =  FMT((Y.TEMP.SEQ + 1), 'R0%7')
        END
        ELSE
            Y.NEW.SEQ = Y.TEMP.SEQ
        END
        Y.MICR.NEW.ID = Y.MICR.ID:".":Y.NEW.SEQ

        EB.DataAccess.FRead(FN.CHQ.ISS.NAU,Y.MICR.NEW.ID,REC.ISS,F.CHQ.ISS.NAU,ERR.NAU)

        REC.ISS<CQ.ChqIssue.ChequeIssue.ChequeIsChqNoStart>=Y.STARTING.NO
        REC.ISS<CQ.ChqIssue.ChequeIssue.ChequeIsNumberIssued>=Y.NUMBER.ISSUED
        REC.ISS<CQ.ChqIssue.ChequeIssue.ChequeIsNotes>=EB.SystemTables.getRNew(EB.JBL82.DISPUT.REASON)
        REC.ISS<CQ.ChqIssue.ChequeIssue.ChequeIsInputter>=REC.MICR<EB.JBL82.INPUTTER>
        REC.ISS<CQ.ChqIssue.ChequeIssue.ChequeIsAuthoriser>=EB.SystemTables.getOperator()
        REC.ISS<CQ.ChqIssue.ChequeIssue.ChequeIsDateTime>=EB.SystemTables.getToday()

        WRITE REC.ISS TO F.CHQ.ISS.NAU,Y.MICR.NEW.ID

        Y.CMD="SELECT FBNK.CHEQUE.ISSUE$NAU WITH @ID EQ ":Y.MICR.NEW.ID
        EXECUTE Y.CMD
        Y.CMD="COPY FROM FBNK.CHEQUE.ISSUE$NAU TO FBNK.CHEQUE.ISSUE$HIS"
        EXECUTE Y.CMD
        Y.CMD="DELETE FBNK.CHEQUE.ISSUE$NAU ":Y.MICR.NEW.ID
        EXECUTE Y.CMD
    END
RETURN
END
