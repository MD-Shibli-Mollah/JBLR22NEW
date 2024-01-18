*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE JBL.API.RES(Y.RESULT)
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_F.ACCOUNT
    $INSERT GLOBUS.BP I_F.ACCOUNT.CLASS
    $INSERT GLOBUS.BP I_F.ACCT.ACTIVITY
    $INSERT GLOBUS.BP I_ENQUIRY.COMMON
    $INSERT GLOBUS.BP I_F.ALTERNATE.ACCOUNT
    $INSERT GLOBUS.BP I_F.CUSTOMER
    $INSERT GLOBUS.BP I_F.COMPANY
    $INSERT GLOBUS.BP I_F.POSTING.RESTRICT

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    RETURN

*------
INIT:
*------
    LOCATE "ACCOUNT.NUMBER" IN ENQ.SELECTION<2,1> SETTING ID.POS THEN
        Y.ID = ENQ.SELECTION<4,ID.POS>
    END

    Y.T24.ID = ""
    Y.ALT.ID = ""
    Y.CUS.ID = ''
    Y.CUS.NAME = ''
    Y.FLAG = 1


    FN.CUS = "FBNK.CUSTOMER"
    F.CUS  = ""
    R.CUS = ""

    FN.AC = "FBNK.ACCOUNT"
    F.AC = ""
    R.AC = ""

    FN.ALT.AC = "F.ALTERNATE.ACCOUNT"
    F.ALT.AC = ""
    R.ALT.AC = ""
    FN.COM = "F.COMPANY"
    F.COM = ""
    FN.PSR= "F.POSTING.RESTRICT"
    F.PSR = ""
    RETURN

*---------
OPENFILES:
*---------
    CALL OPF( FN.CUS, F.CUS )
    CALL OPF(FN.AC, F.AC)
    CALL OPF(FN.ALT.AC, F.ALT.AC)
    CALL OPF(FN.COM, F.COM)
    CALL OPF(FN.PSR, F.PSR)
    RETURN

*--------
PROCESS:
*--------

    CALL F.READ(FN.ALT.AC, Y.ID, R.ALT.AC, F.ALT.AC, ERR.ALT.AC)

    IF R.ALT.AC THEN
        Y.T24.ID = R.ALT.AC<AAC.GLOBUS.ACCT.NUMBER>
        Y.ALT.ID = Y.ID
    END
    ELSE
        Y.T24.ID = Y.ID
    END

    IF Y.T24.ID THEN
        CALL F.READ(FN.AC, Y.T24.ID, R.AC, F.AC, ERR.AC)
        Y.ALT.ID = R.AC<AC.ALT.ACCT.ID>
        Y.CUS.ID = R.AC<AC.CUSTOMER>
        IF Y.CUS.ID THEN
            CALL F.READ( FN.CUS, Y.CUS.ID, R.CUS, F.CUS, ERR.CUS )
            Y.CUS.NAME = R.CUS<EB.CUS.NAME.1>
            Y.MOBILE = R.CUS<EB.CUS.SMS.1>
            Y.NID= R.CUS<EB.CUS.LEGAL.ID>
        END
        Y.PR = R.AC<AC.POSTING.RESTRICT>
        IF Y.PR THEN
            CALL F.READ(FN.PSR,Y.PR,R.PR,F.PSR,PR.ERR)
            Y.DES = R.PR<AC.POS.DESCRIPTION>
            Y.PR.TYPE = R.PR<AC.POS.RESTRICTION.TYPE>
            IF Y.PR.TYPE EQ "ALL" OR Y.PR.TYPE EQ "CREDIT" THEN
                Y.FLAG = 0
            END
        END
        Y.CO.CODE = R.AC<AC.CO.CODE>
        IF Y.CO.CODE THEN
            CALL F.READ(FN.COM,Y.CO.CODE,R.COM,F.COM,ERR.COM)
            Y.BR.NAME = R.COM<EB.COM.COMPANY.NAME>
        END
        Y.AC.INACTIVE = R.AC<AC.INACTIV.MARKER>
        IF Y.AC.INACTIVE EQ "Y" THEN
            Y.FLAG = 0
        END
    END

    IF Y.CO.CODE NE "" THEN
        Y.RESULT = "Successful":"*":"200":"*":Y.FLAG:'*':Y.T24.ID:"*":Y.ALT.ID:"*":Y.CUS.NAME:"*":Y.MOBILE:"*":Y.NID:"*":Y.CO.CODE:"*":Y.BR.NAME
    END
    ELSE
        Y.RESULT = "Invalid Account Number":"*":"407":"*":"*":"*":"*":"*":"*":"*":"*":"*":"*":"*"
    END
    RETURN
END
