*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
!PROGRAM JBL.API.CHECK.BAL
    SUBROUTINE JBL.API.CHECK.BAL(Y.RESULT)

    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_F.ACCOUNT
    $INSERT GLOBUS.BP I_ENQUIRY.COMMON
    $INSERT GLOBUS.BP I_F.CUSTOMER
    $INSERT GLOBUS.BP I_F.COMPANY
    $INSERT BP I_F.API.SYS.INFO


    FN.CUS = "FBNK.CUSTOMER"
    F.CUS  = ""
    R.CUS = ""

    FN.AC = "FBNK.ACCOUNT"
    F.AC = ""
    R.AC = ""

    FN.COM = "F.COMPANY"
    F.COM = ""

    FN.SYS.INFO = 'F.EB.API.SYS.INFO'
    F.SYS.INFO = ''

    Y.T24.ID=""

    CALL OPF(FN.AC, F.AC)
    CALL OPF(FN.COM,F.COM)
    CALL OPF(FN.SYS.INFO, F.SYS.INFO)

    LOCATE "ACCOUNT.NUMBER" IN ENQ.SELECTION<2,1> SETTING ID.POS THEN
        Y.T24.ID = ENQ.SELECTION<4,ID.POS>
    END
    IF LEN(Y.T24.ID) EQ '16' AND ISALNUM(Y.T24.ID) EQ "1" THEN

        CALL F.READ(FN.SYS.INFO,'FRD',R.INFO,F.SYS.INFO,ERR.INFO)

        IF R.INFO NE "" THEN
            Y.DR.AC = R.INFO<EB.API64.DEBIT.ACCT.NO>
            CONVERT VM TO FM IN Y.DR.AC
            LOCATE Y.T24.ID IN Y.DR.AC SETTING POS THEN
                Y.ID = R.INFO<EB.API64.DEBIT.ACCT.NO,POS>
            END
            ELSE
                Y.RESULT = "Invalid Account Number":"*":"407":"*":"*":"*":"*":"*"
            END
        END
        IF Y.ID NE "" THEN
            CALL F.READ(FN.AC, Y.ID, R.AC, F.AC, ERR.AC)
            Y.AC.TITLE = R.AC<AC.ACCOUNT.TITLE.1>
            Y.GL.BAL = R.AC<AC.WORKING.BALANCE>
            Y.BAL = R.AC<AC.OPEN.ACTUAL.BAL>
            Y.CO.CODE = R.AC<AC.CO.CODE>
            IF Y.CO.CODE THEN
                CALL F.READ(FN.COM,Y.CO.CODE,R.COM,F.COM,ERR.COM)
                Y.BR.NAME = R.COM<EB.COM.COMPANY.NAME>
            END
            IF Y.T24.ID EQ Y.ID THEN
                Y.RESULT="Successful":"*":"200":"*":Y.AC.TITLE:"*":Y.GL.BAL:"*":Y.CO.CODE:"*":Y.BR.NAME
            END
            ELSE
                Y.RESULT="Invalid Account Number":"*":"407":"*":"*":"*":"*":"*"
            END
        END
    END
    ELSE
        Y.RESULT="Account length must be 16 digit":"*":"407":"*":"*":"*":"*":"*"

    END
    RETURN
END
