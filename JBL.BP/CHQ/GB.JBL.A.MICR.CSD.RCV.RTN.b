* @ValidationCode : MjotMTc5MDA3MDQ4NTpDcDEyNTI6MTY2MDY0ODUyMjU5NDpuYXppYjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9TUDkuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Aug 2022 17:15:22
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
SUBROUTINE GB.JBL.A.MICR.CSD.RCV.RTN
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

    FN.MICR.BATCH='FBNK.EB.JBL.MICR.CHQ.BATCH'
    F.MICR.BATCH=''

RETURN
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.MICR.BATCH,F.MICR.BATCH)

RETURN
*-------
PROCESS:
*-------
    !DEBUG
    IF EB.SystemTables.getVFunction() EQ 'A' THEN
        ! Y.BATCH.NO='MICR.20220307.142221'
        Y.BATCH.NO = EB.SystemTables.getRNew(EB.JBL82.BATCH.NO)
        Y.REQ.BOOK = EB.SystemTables.getRNew(EB.JBL82.NO.OF.BOOK)

        EB.DataAccess.FRead(FN.MICR.BATCH,Y.BATCH.NO,R.BATCH.REC,F.MICR.BATCH,Y.ERR)
        Y.PENDING=R.BATCH.REC<EB.JBL38.PENDING.BOOK>

        R.BATCH.REC<EB.JBL38.PENDING.BOOK>= Y.PENDING -Y.REQ.BOOK
        R.BATCH.REC<EB.JBL38.BOOK.RECEIVE.DATE>= EB.SystemTables.getToday()
        R.BATCH.REC<EB.JBL38.STATUS>= 'PRINTED'
*EB.DataAccess.FWrite(FN.MICR.BATCH,Y.BATCH.NO,R.BATCH.REC)
        WRITE R.BATCH.REC ON F.MICR.BATCH,Y.BATCH.NO
        
    END
RETURN
END
