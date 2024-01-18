*-----------------------------------------------------------------------------
* <Rating>399</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE CORRECT.SP

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.STATEMENT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.DATES


    FN.SP = "F.STMT.PRINTED"
    F.SP = ""
    CALL OPF(FN.SP,F.SP)

    FN.ASP = "F.ACCT.STMT.PRINT"
    F.ASP = ""
    CALL OPF(FN.ASP,F.ASP)

    FN.STMT.ENTRY = "F.STMT.ENTRY"
    F.STMT.ENTRY = ""
    CALL OPF(FN.STMT.ENTRY, F.STMT.ENTRY)

    ENTRY.REC=""
    FINAL.REC =""
    WRITE.POS = ""

    SEL.CMD = "GET.LIST ID.PROCESS"

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ACCT.ERR)
    LOOP

        REMOVE TEMP.ID FROM SEL.LIST SETTING POS

    WHILE TEMP.ID:POS

        ASP.ID = FIELD(TEMP.ID,'*',1)
        ENTRY = FIELD(TEMP.ID,'*',2)


        ASP.REC = "" ; R.AS = ""

        READ ASP.REC FROM F.ASP, ASP.ID ELSE ASP.REC = ""

        STMT.DATES = FIELDS(ASP.REC,"/",1,1)

        STMT.BALS = FIELDS(ASP.REC,"/",2,1)

        NEXT.DATE.NO = DCOUNT(STMT.DATES,@FM)

        START.DATE = "20140317"

        LOCATE START.DATE IN STMT.DATES<1> BY "AR" SETTING CONT.POS ELSE

            CONT.POS = CONT.POS - 1
        END

        IF NOT(CONT.POS) THEN CONT.POS = NEXT.DATE.NO

        SP.DATE = STMT.DATES<CONT.POS>

        SP.ID = ASP.ID:"-":SP.DATE

        READU R.SP FROM F.SP, SP.ID ELSE R.SP = ""

        LOCATE ENTRY IN R.SP SETTING WRITE.POS ELSE WRITE.POS =""


        IF NOT(WRITE.POS) THEN

            R.SP<-1> = ENTRY

            R.SP = SORT(R.SP)

            WRITE R.SP TO F.SP, SP.ID


        END

        RELEASE F.SP, SP.ID

    REPEAT

    RETURN

END
