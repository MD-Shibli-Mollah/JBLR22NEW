* @ValidationCode : Mjo1OTE5OTQyMDc6Q3AxMjUyOjE2NjA2MzM1MTM2NDA6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Aug 2022 13:05:13
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
SUBROUTINE GB.JBL.I.MICR.WR.TO.CHQ.ISS
*
*Retrofitted By:
*    Date         : 16/08/2022
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
    $USING EB.Interface
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

*------
INIT:
*------
    FN.CHQ.ISS = 'F.CHEQUE.ISSUE'
    F.CHQ.ISS = ''

    FN.CHQ.ISS.NAU='F.CHEQUE.ISSUE$NAU'
    F.CHQ.ISS.NAU=''

    FN.CHQ.ISS.HIS='F.CHEQUE.ISSUE$HIS'
    F.CHQ.ISS.HIS=''

    Y.SOURCE="JBL.DM.OFS.SRC.VAL"

    Y.MICR.ID = ''
RETURN
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.CHQ.ISS,F.CHQ.ISS)
    EB.DataAccess.Opf(FN.CHQ.ISS.NAU,F.CHQ.ISS.NAU)
    EB.DataAccess.Opf(FN.CHQ.ISS.HIS,F.CHQ.ISS.HIS)

RETURN
*-------
PROCESS:
*-------
   
    Y.REQ.BOOK = EB.SystemTables.getRNew(EB.JBL82.NO.OF.BOOK)
    Y.LEAF.TYPE = EB.SystemTables.getRNew(EB.JBL82.LEAF.TYPE)
    Y.PREFIX.NO = EB.SystemTables.getRNew(EB.JBL82.PREFIX.NO)
    Y.STARTING.NO = EB.SystemTables.getRNew(EB.JBL82.STARTING.NO)
    Y.CHQ.TYPE = EB.SystemTables.getRNew(EB.JBL82.CHQ.TYPE)
    Y.CO.CODE = EB.SystemTables.getRNew(EB.JBL82.BRANCH.CODE)
    Y.T24.AC = EB.SystemTables.getRNew(EB.JBL82.ACCOUNT)
    Y.MICR.ID = Y.CHQ.TYPE:".":Y.T24.AC

    IF EB.SystemTables.getVFunction() EQ "I" THEN

        FOR I=1 TO Y.REQ.BOOK

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

            Y.MESSAGE="CHEQUE.ISSUE,JBL.MICR/I/PROCESS,//":Y.CO.CODE:",":Y.MICR.NEW.ID:",CHEQUE.STATUS=90,ISSUE.DATE=":EB.SystemTables.getToday():",NUMBER.ISSUED=":Y.LEAF.TYPE:",CHQ.NO.START=":Y.PREFIX.NO:Y.STARTING.NO

            RUNNING.UNDER.BATCH=1
            !EB.Interface.OfsGlobusManager(Y.SOURCE,Y.MESSAGE)
	    EB.Interface.OfsCallBulkManager(Y.SOURCE,Y.MESSAGE, theResponse, txnCommitted)

            RUNNING.UNDER.BATCH=0
            SENSITIVITY=''

            Y.STATUS =FIELD(FIELD(Y.MESSAGE,"/",3,1),",",1)

            Y.STARTING.NO = FMT((Y.STARTING.NO + Y.LEAF.TYPE), 'R0%7')

        NEXT I
    END
    ELSE IF EB.SystemTables.getVFunction() EQ "A" THEN
        SEL.CMD.NAU = "SELECT ":FN.CHQ.ISS.NAU: " WITH @ID LIKE '":Y.MICR.ID:"...' AND REQ.REF EQ ":EB.SystemTables.getIdNew()
        EB.DataAccess.Readlist(SEL.CMD.NAU,SEL.LIST.NAU,'',NO.OF.REC.NAU,RET.CODE.NAU)

        FOR I = 1 TO NO.OF.REC.NAU

            Y.CHQ.ISS.ID = SEL.LIST.NAU<I>
            Y.MESSAGE="CHEQUE.ISSUE,JBL.MICR/A/PROCESS,//":Y.CO.CODE:",":Y.CHQ.ISS.ID

            RUNNING.UNDER.BATCH=1
            !EB.Interface.OfsGlobusManager(Y.SOURCE,Y.MESSAGE)
	    EB.Interface.OfsCallBulkManager(Y.SOURCE,Y.MESSAGE, theResponse, txnCommitted)

            RUNNING.UNDER.BATCH=0
            SENSITIVITY=''

            Y.STATUS =FIELD(FIELD(Y.MESSAGE,"/",3,1),",",1)
        NEXT I
    END
    ELSE IF EB.SystemTables.getVFunction() EQ "D" THEN
        SEL.CMD.NAU = "SELECT ":FN.CHQ.ISS.NAU: " WITH @ID LIKE '":Y.MICR.ID:"...' AND REQ.REF EQ ":EB.SystemTables.getIdNew()
        EB.DataAccess.Readlist(SEL.CMD.NAU,SEL.LIST.NAU,'',NO.OF.REC.NAU,RET.CODE.NAU)

        FOR I = 1 TO NO.OF.REC.NAU

            Y.CHQ.ISS.ID = SEL.LIST.NAU<I>
            Y.MESSAGE="CHEQUE.ISSUE,JBL.MICR/D/PROCESS,//":Y.CO.CODE:",":Y.CHQ.ISS.ID

            RUNNING.UNDER.BATCH=1
            !EB.Interface.OfsGlobusManager(Y.SOURCE,Y.MESSAGE)
	    EB.Interface.OfsCallBulkManager(Y.SOURCE,Y.MESSAGE, theResponse, txnCommitted)

            RUNNING.UNDER.BATCH=0
            SENSITIVITY=''

            Y.STATUS =FIELD(FIELD(Y.MESSAGE,"/",3,1),",",1)

        NEXT I
    END

RETURN
END
