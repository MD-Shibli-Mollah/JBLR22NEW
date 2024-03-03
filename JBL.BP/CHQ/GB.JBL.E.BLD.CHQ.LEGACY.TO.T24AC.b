* @ValidationCode : MjotMTIyOTUzNzc3NDpDcDEyNTI6MTY2MDczODg1NzcxNjpuYXppYjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9TUDkuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Aug 2022 18:20:57
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
SUBROUTINE GB.JBL.E.BLD.CHQ.LEGACY.TO.T24AC(ENQ.DATA)
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
    $INSERT  I_ENQUIRY.COMMON
    $INSERT  I_F.ACCOUNT
    
    $USING EB.DataAccess

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
INITIALISE:

    Y.AC.ID = ''

RETURN          ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:

    FN.AC = "F.ACCOUNT"
    F.AC = ""

    FN.ALT.AC='F.ALTERNATE.ACCOUNT'
    F.ALT.AC=''

    EB.DataAccess.Opf(FN.AC,F.AC)
    EB.DataAccess.Opf(FN.ALT.AC,F.ALT.AC)

RETURN          ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------
PROCESS:

    LOCATE "ACCOUNT" IN ENQ.DATA<2,1> SETTING Y.POS THEN
        Y.AC.ID= ENQ.DATA<4,Y.POS>
        !CRT Y.AC.ID
        !    DEBUG
        !Y.AC.ID = '0212031S001328'
        IF Y.AC.ID THEN
            EB.DataAccess.FRead(FN.ALT.AC,Y.AC.ID,R.ALT.AC,F.ALT.AC,ERR.ALT)

            IF R.ALT.AC NE "" THEN
                Y.T24.AC=FIELD(R.ALT.AC,"*",2)
            END ELSE
                Y.T24.AC= Y.AC.ID
            END
            !CRT Y.T24.AC
            ENQ.DATA<2,Y.POS> = '@ID'
            ENQ.DATA<3,Y.POS> = 'CT'
            ENQ.DATA<4,Y.POS> = Y.T24.AC
        END
    END

RETURN

END
