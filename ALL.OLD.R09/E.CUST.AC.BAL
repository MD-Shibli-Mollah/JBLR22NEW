*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE E.CUST.AC.BAL(ENQ.DATA)
*
* * Error Variables:
* ----------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
    LOCATE 'ACCOUNT.NO' IN ENQ.DATA<2,1> SETTING CUS.CODE.POS THEN
        Y.AC.ID = ENQ.DATA<4,CUS.CODE.POS>
        IF Y.AC.ID THEN
            ENQ.DATA<2,CUS.CODE.POS> = '@ID'
            ENQ.DATA<3,CUS.CODE.POS> = 'EQ'
            ENQ.DATA<4,CUS.CODE.POS> = Y.AC.ID
        END
    END

    RETURN
*-----------------------------------------------------------------------------------
INITIALISE:

    Y.AC.ID = ''

    RETURN          ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:

    FN.AC = "F.ACCOUNT"
    F.AC = ""
    CALL OPF(FN.AC,F.AC)

    RETURN          ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
END
