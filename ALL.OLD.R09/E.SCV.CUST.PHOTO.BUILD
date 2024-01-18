*-----------------------------------------------------------------------------
* <Rating>-34</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE E.SCV.CUST.PHOTO.BUILD(ENQ.DATA)
*
* Subroutine Type : BUILD Routine
* Attached to     : CUST.PHOTO.RTN.SCV
* Attached as     : Build Routine
* Primary Purpose : We need a way of searching a customer based on any products held should
*                   also be able to link the photo of the customer (from IM.DOCUMENT.IMAGE)
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
* ----------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:

    LOCATE 'IMAGE.REFERENCE' IN ENQ.DATA<2,1> SETTING CUS.CODE.POS THEN
!--------1/S-----!
        CALL F.READ(FN.ALTER,ENQ.DATA<4,CUS.CODE.POS>,R.ALTER,F.ALTER,ERR.ALT)
        IF R.ALTER THEN
            Y.CUST.ID = "BNK_" :R.ALTER<1>
        END
        ELSE
            Y.CUST.ID = "BNK_" : ENQ.DATA<4,CUS.CODE.POS>
        END
!-------1/E-------!
!        Y.CUST.ID = "BNK_" : ENQ.DATA<4,CUS.CODE.POS>
        IF Y.CUST.ID THEN
            CALL F.READ(FN.IM.REFERENCE,Y.CUST.ID,R.IM.REFERENCE,F.IM.REFERENCE,ERR.IM.REF)
            IF R.IM.REFERENCE EQ "" THEN
                Y.CUST.ID = ENQ.DATA<4,CUS.CODE.POS>
                CALL F.READ(FN.IM.REFERENCE,Y.CUST.ID,R.IM.REFERENCE,F.IM.REFERENCE,ERR.IM.REF)
                CONVERT @FM TO " " IN R.IM.REFERENCE
                ENQ.DATA<2,CUS.CODE.POS> = '@ID'
                ENQ.DATA<3,CUS.CODE.POS> = 'EQ'
                ENQ.DATA<4,CUS.CODE.POS> = R.IM.REFERENCE
            END ELSE
                CONVERT @FM TO " " IN R.IM.REFERENCE
                ENQ.DATA<2,CUS.CODE.POS> = '@ID'
                ENQ.DATA<3,CUS.CODE.POS> = 'EQ'
                ENQ.DATA<4,CUS.CODE.POS> = R.IM.REFERENCE
            END
        END
    END

    RETURN
*-----------------------------------------------------------------------------------
INITIALISE:

    Y.CUST.ID = ''
    R.ALTER=''
    RETURN          ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:

    FN.IM.REFERENCE = "F.IM.REFERENCE"
    F.IM.REFERENCE = ""
    CALL OPF(FN.IM.REFERENCE,F.IM.REFERENCE)

    FN.ALTER ="F.ALTERNATE.ACCOUNT"
    F.ALTER=''
    CALL OPF(FN.ALTER,F.ALTER)

    RETURN          ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
END
