*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    PROGRAM AC.BAL
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    ACCOUNT.NO = "BDT1281050610902"
    START.DATE = "20120131"
    ACCOUNT.BAL=""
    CALL GET.ENQ.BALANCE(ACCOUNT.NO,START.DATE,ACCOUNT.BAL)

    PRINT" ":ACCOUNT.BAL
END
