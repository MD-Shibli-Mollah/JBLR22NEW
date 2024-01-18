*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE E.ABL.AC.BOOK.DATE.BAL(Y.RETURN)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_ENQUIRY.COMMON

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    RETURN

INIT:

    Y.ACCT.ID=''
    Y.ACCT.REC=''
    Y.BALANCE.TYPE='VALUE'

    LOCATE "DATE" IN ENQ.SELECTION<2,1> SETTING DATE.POS THEN
        Y.BALANCE.DATE = ENQ.SELECTION<4,DATE.POS>
        IF Y.BALANCE.DATE EQ "" THEN
            Y.BALANCE.DATE = TODAY
        END
    END

    Y.SYSTEM.DATE=''

    Y.BALANCE=''
    Y.CREDIT.MVMT=''
    Y.DEBIT.MVMT=''
    Y.ERR.MSG=''
    Y.CAL=''

    FN.AC='F.ACCOUNT'
    F.AC=''

    FN.AC.HIS='F.ACCOUNT$HIS'
    F.AC.HIS=''

    FN.AC.CLOSE = 'F.ACCOUNT.CLOSED'
    F.AC.CLOSE = ''

    FN.AC.CLASS = "F.ACCOUNT.CLASS"
    F.AC.CLASS = ""

    REC.AC=''
    REC.AC.HIS=''

    LOCATE "CATEGORY" IN ENQ.SELECTION<2,1> SETTING CATEGORY.POS THEN
        Y.CATEGORY = ENQ.SELECTION<4,CATEGORY.POS>
        CONVERT SM TO " " IN Y.CATEGORY
    END

    Y.CATEG.LIST = ''
    Y.RESULT=''
    Y.BLANK=''
    RETURN

OPENFILES:
    CALL OPF(FN.AC,F.AC)
    CALL OPF(FN.AC.CLOSE,F.AC.CLOSE)
    CALL OPF(FN.AC.HIS,F.AC.HIS)
    CALL OPF(FN.AC.CLASS,F.AC.CLASS)
    RETURN

PROCESS:

    CALL F.READ(FN.AC.CLASS,Y.CATEGORY,R.AC.CLASS.REC,F.AC.CLASS,Y.ERR)
    Y.CATEG.COUNT = DCOUNT(R.AC.CLASS.REC<3>,@VM)
    FOR I = 1 TO Y.CATEG.COUNT
        INS R.AC.CLASS.REC<3,I> BEFORE Y.CATEG.LIST<0,0,0>
    NEXT
    CONVERT FM TO " " IN Y.CATEG.LIST

********************************************
!Read Account Balance from Live Account File
********************************************

    IF Y.CATEG.LIST NE "" THEN
************IF Record ID Select From ACCOUNT.CLASS File **************
        SEL.CMD.AC = "SSELECT ":FN.AC:" WITH CO.CODE EQ ":ID.COMPANY:" AND CATEGORY EQ ":Y.CATEG.LIST
    END ELSE
        IF Y.CATEG.LIST EQ "" THEN
************IF Individual Category Provided in Selection Field********
            SEL.CMD.AC = "SSELECT ":FN.AC:" WITH CO.CODE EQ ":ID.COMPANY:" AND CATEGORY EQ ":Y.CATEGORY
        END
    END

    CALL EB.READLIST(SEL.CMD.AC,SEL.LIST.AC,'',AC.REC.NO,AC.RET.CODE)

    LOOP
        REMOVE Y.ACCT.ID FROM SEL.LIST.AC SETTING POS
    WHILE Y.ACCT.ID:POS

        CALL EB.GET.ACCT.BALANCE(Y.ACCT.ID,Y.ACCT.REC,Y.BALANCE.TYPE,Y.BALANCE.DATE,Y.SYSTEM.DATE,Y.BALANCE,Y.CREDIT.MVMT,Y.DEBIT.MVMT,Y.ERR.MSG)

        IF Y.BALANCE NE 0 THEN

            CALL F.READ(FN.AC,Y.ACCT.ID,REC.AC,F.AC,ERR.AC)
***************To Identify -ve or +ve Balance****************
            IF Y.BALANCE LT 0 THEN
                Y.RESULT=Y.ACCT.ID:"*":Y.BALANCE:"*":Y.BLANK:"*":REC.AC<AC.ACCOUNT.TITLE.1>:"*":REC.AC<AC.ALT.ACCT.ID>
            END ELSE
                Y.RESULT=Y.ACCT.ID:"*":Y.BLANK:"*":Y.BALANCE:"*":REC.AC<AC.ACCOUNT.TITLE.1>:"*":REC.AC<AC.ALT.ACCT.ID>
            END
*************************************************************
            Y.CAL<-1>=Y.RESULT

        END
    REPEAT

    Y.ACCT.ID =''

**********************************************
!Read Account Balance from Closed Account File
**********************************************

    IF Y.CATEG.LIST NE "" THEN
************IF Record ID Select From ACCOUNT.CLASS File **************
        SEL.CMD.AC.CLOSE = "SSELECT ":FN.AC.CLOSE:" WITH CO.CODE EQ ":ID.COMPANY:" AND ACCT.CLOSE.DATE GE ":Y.BALANCE.DATE:" AND CATEGORY EQ ":Y.CATEG.LIST
    END ELSE
        IF Y.CATEG.LIST EQ "" THEN
************IF Individual Category Provided in Selection Field********
            SEL.CMD.AC.CLOSE = "SSELECT ":FN.AC.CLOSE:" WITH CO.CODE EQ ":ID.COMPANY:" AND ACCT.CLOSE.DATE GE ":Y.BALANCE.DATE:" AND CATEGORY EQ ":Y.CATEGORY
        END
    END

    CALL EB.READLIST(SEL.CMD.AC.CLOSE,SEL.LIST.AC.CLOSE,'',CLOSE.AC.REC.NO,CLOSE.AC.RET.CODE)
    LOOP
        REMOVE Y.ACCT.ID FROM SEL.LIST.AC.CLOSE SETTING POS

    WHILE Y.ACCT.ID:POS
        CALL EB.GET.ACCT.BALANCE(Y.ACCT.ID,Y.ACCT.REC,Y.BALANCE.TYPE,Y.BALANCE.DATE,Y.SYSTEM.DATE,Y.BALANCE,Y.CREDIT.MVMT,Y.DEBIT.MVMT,Y.ERR.MSG)

        IF Y.BALANCE NE 0 THEN
            Y.ACCT.ID=Y.ACCT.ID:";1"
            CALL F.READ(FN.AC.HIS,Y.ACCT.ID,REC.AC.HIS,F.AC.HIS,ERR.AC.HIS)
***************To Identify -ve or +ve Balance****************
            IF Y.BALANCE LT 0 THEN
                Y.RESULT=Y.ACCT.ID:"*":Y.BALANCE:"*":Y.BLANK:"*":REC.AC.HIS<AC.ACCOUNT.TITLE.1>:"*":REC.AC.HIS<AC.ALT.ACCT.ID>
            END ELSE
                Y.RESULT=Y.ACCT.ID:"*":Y.BLANK:"*":Y.BALANCE:"*":REC.AC.HIS<AC.ACCOUNT.TITLE.1>:"*":REC.AC.HIS<AC.ALT.ACCT.ID>
            END
*************************************************************
            Y.CAL<-1>=Y.RESULT

        END

    REPEAT
    Y.RETURN<-1>=Y.CAL
*PRINT Y.RETURN

    RETURN

END
