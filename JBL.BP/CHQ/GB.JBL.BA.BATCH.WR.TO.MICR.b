* @ValidationCode : MjotNTQ5NjMzMTQ5OkNwMTI1MjoxNjYwNjQ4NjA3NDU5Om5hemliOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Aug 2022 17:16:47
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
SUBROUTINE GB.JBL.BA.BATCH.WR.TO.MICR
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
    $INSERT  I_F.EB.JBL.MICR.MGT
    $INSERT  I_F.EB.JBL.MICR.CHQ.BATCH

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.Interface
    $USING EB.SystemTables
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

*------
INIT:
*------

    FN.CHQ.ISS.NAU='FBNK.EB.JBL.MICR.MGT$NAU'
    F.CHQ.ISS.NAU=''

    Y.SOURCE="DM.OFS.SRC.VAL"
RETURN
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.CHQ.ISS.NAU,F.CHQ.ISS.NAU)

RETURN
*-------
PROCESS:
*-------
    Y.IDS=EB.SystemTables.getRNew(EB.JBL38.REQUEST.ID)

    IF Y.IDS EQ "" AND EB.SystemTables.getVFunction() EQ "A" THEN
        EB.SystemTables.setEtext("REQUEST ID MISSING")
        EB.ErrorProcessing.StoreEndError()
    END

    IF Y.IDS NE "" THEN

        !DEBUG
        LOOP
            REMOVE Y.ID FROM Y.IDS SETTING POS
        WHILE Y.ID:POS
            IF EB.SystemTables.getVFunction()EQ "A" THEN
                Y.MESSAGE="EB.JBL.MICR.MGT,PRINTING/A/PROCESS,//,":Y.ID

                RUNNING.UNDER.BATCH=1
                EB.Interface.OfsGlobusManager(Y.SOURCE,Y.MESSAGE)

                RUNNING.UNDER.BATCH=0
                SENSITIVITY=''


                Y.STATUS =FIELD(FIELD(Y.MESSAGE,"/",3,1),",",1)

                EB.SystemTables.setRNew(EB.JBL38.STATUS, "PRINTING")
            END

            IF EB.SystemTables.getVFunction() EQ "D" THEN
                EB.DataAccess.FRead(FN.CHQ.ISS.NAU,Y.ID,REC.CHQ.REQ,F.CHQ.ISS.NAU,ERR.REQ)
                REC.CHQ.REQ<EB.JBL82.BATCH.NO>=""
                REC.CHQ.REQ<EB.JBL82.STATUS>="PROCESSING"
                WRITE REC.CHQ.REQ ON F.CHQ.ISS.NAU,Y.ID
            END
        REPEAT
    END
RETURN
END
