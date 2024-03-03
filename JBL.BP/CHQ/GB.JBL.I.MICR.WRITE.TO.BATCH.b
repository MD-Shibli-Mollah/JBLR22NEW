* @ValidationCode : MjotMjAwMzA0MTY1OkNwMTI1MjoxNjYwNjQ5MjgyMjIzOm5hemliOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Aug 2022 17:28:02
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
SUBROUTINE GB.JBL.I.MICR.WRITE.TO.BATCH
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
    $USING EB.SystemTables

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
*------
INIT:
*------
    FN.CHQ.BATCH = 'FBNK.EB.JBL.MICR.CHQ.BATCH$NAU'
    F.CHQ.BATCH = ''

    FN.CHQ.ISS='FBNK.EB.JBL.MICR.MGT'
    F.CHQ.ISS=''
RETURN
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.CHQ.BATCH,F.CHQ.BATCH)
    EB.DataAccess.Opf(FN.CHQ.ISS,F.CHQ.ISS)

RETURN
*-------
PROCESS:
*-------
    !DEBUG
    Y.BATCH.ID=EB.SystemTables.getRNew(EB.JBL82.BATCH.NO)
    !Y.BATCH.ID='MICR.2343244.4543535'
    Y.REQ.ID=EB.SystemTables.getIdNew()
    !Y.REQ.ID = 'DD.0100191870241.20220301151041'

    Y.REQ.BOOK = EB.SystemTables.getRNew(EB.JBL82.NO.OF.BOOK)
    IF EB.SystemTables.getVFunction() EQ "I" THEN
        EB.DataAccess.FRead(FN.CHQ.BATCH,Y.BATCH.ID,REC.BATCH,F.CHQ.BATCH,ERR.BATCH)
        IF REC.BATCH NE '' THEN
            Y.COUNT.ID = DCOUNT(REC.BATCH<EB.JBL38.REQUEST.ID>,@VM)
            IF Y.COUNT.ID EQ 0 THEN
                REC.BATCH<EB.JBL38.REQUEST.ID>=Y.REQ.ID
                REC.BATCH<EB.JBL38.PENDING.BOOK> = Y.REQ.BOOK
                REC.BATCH<EB.JBL38.STATUS> = "PROCESSING"
                REC.BATCH<EB.JBL38.PRINT.REQ.DATE> = EB.SystemTables.getToday()
            END
            ELSE
                REC.BATCH<EB.JBL38.REQUEST.ID>=REC.BATCH<EB.JBL38.REQUEST.ID>:@VM:Y.REQ.ID
                REC.BATCH<EB.JBL38.PENDING.BOOK> = REC.BATCH<EB.JBL38.PENDING.BOOK> + Y.REQ.BOOK
                REC.BATCH<EB.JBL38.PRINT.REQ.DATE> = EB.SystemTables.getToday()
            END
            !IF REC.BATCH<CHQ.BATCH.PENDING.BOOK> EQ REC.BATCH<CHQ.BATCH.TOTAL.BOOK> THEN
            !   REC.BATCH<CHQ.BATCH.STATUS> = "PRINTING"
            !  REC.BATCH<CHQ.BATCH.PRINT.REQ.DATE> = TODAY
            !END
            WRITE REC.BATCH ON F.CHQ.BATCH,Y.BATCH.ID
        END
    END
RETURN
END
