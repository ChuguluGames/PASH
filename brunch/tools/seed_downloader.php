#!/usr/bin/env php
<?php

class PackState {
    const AVAILABLE     = 0;
    const INCOMPLETE    = 3;
    const READY_TO_PLAY = 4;
    const SELECTED      = 5;
}

class SeedJSONDownloader {
  private $locales = array();
  private $baseUrl = NULL;
  private $basePackIds = array();

  private $imgsDone = FALSE;

  public function __construct() {
  }

  public function setBasePAckIds($newIds) {
    $this->basePackIds = $newIds;
  }

  public function setBaseUrl($newUrl) {
    $this->baseUrl = $newUrl;
  }

  public function setLocales($newLocales) {
    $this->locales = $newLocales;
  }

  public function getTagsUrl($locale) {
    return ($this->baseUrl.'/'.$locale.'/tags');
  }

  public function getPacksUrl($locale) {
    return ($this->baseUrl.'/'.$locale.'/packs');
  }

  public function getItemsUrlForPackId($packId, $locale) {
    return ($this->baseUrl.'/'.$locale.'/packs/'.$packId.'/items');
  }

  private function getTagsPath($locale) {
    $path = 'json/'.$locale;
    @mkdir($path, 0755, TRUE);
    return $path.'/tags.json';
  }

  private function getPacksPath($locale) {
    $path = 'json/'.$locale;
    @mkdir($path, 0755, TRUE);
    return $path.'/packs.json';
  }

  private function getItemsPathForPackId($packId, $locale) {
    $path = 'json/'.$locale.'/packs/'.$packId;
    @mkdir($path, 0755, TRUE);
    return $path.'/items.json';
  }

  private function getPackImagePath($packId, $imageName) {
    $path = 'images/pack/'.$packId;
    @mkdir($path, 0755, TRUE);
    return $path.'/'.basename($imageName);
  }

  private function getItemImagePath($itemId, $imageName) {
    $path = 'images/item/'.$itemId;
    @mkdir($path, 0755, TRUE);
    return $path.'/'.basename($imageName);
  }

  private function log($msg) {
    echo $msg,"\n";
  }

  private function downloadFile($url) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_USERAGENT, 'PayboySpots');
    $data = curl_exec($ch);
    curl_close($ch);
    return $data;
  }

  private function downloadTags($locale) {
    $url = $this->getTagsUrl($locale);
    $this->log("Downloading tags [".$locale."] from [".$url."]");
    $tags = $this->downloadFile($url);
    file_put_contents($this->getTagsPath($locale), $tags);
    $this->log("Done tags [".$locale."]");
  }

  private function downloadPackImage($packId, $imgUrl, $type) {
    $ext = explode('.', basename($imgUrl));
    $imgFileName = $type.'.'.$ext[1];
    $img = $this->downloadFile($this->baseUrl.'/'.$imgUrl, $imgFileName);
    file_put_contents($this->getPackImagePath($packId, $imgFileName), $img);
  }

  private function downloadItemImage($itemId, $imgUrl, $type) {
    $ext = explode('.', basename($imgUrl));
    $imgFileName = $type.'.'.$ext[1];
    $img = $this->downloadFile($this->baseUrl.'/'.$imgUrl, $imgFileName);
    file_put_contents($this->getItemImagePath($itemId, $imgFileName), $img);
  }

  private function downloadPacks($locale) {
    $url = $this->getPacksUrl($locale);
    $this->log("Downloading packs [".$locale."] from [".$url."]");
    $packs = $this->downloadFile($url);
    file_put_contents($this->getPacksPath($locale), $packs);
    $packIds = array();
    $packs = json_decode($packs);
    if (is_array($packs))
      foreach ($packs as $pack) {
        if (isset($pack->pack))
          $pack = $pack->pack;
        if (in_array($pack->identity, $this->basePackIds))
          $packIds[] = $pack->identity;
        if (!$this->imgsDone) {
          $this->downloadPackImage($pack->identity, $pack->preview_image_url, 'preview_image');
          $this->downloadPackImage($pack->identity, $pack->cover_image_url, 'cover_image');
        }
      }
    $this->log("Done packs [".$locale."]");
    return $packIds;
  }

  private function downloadItemsForPackId($packId, $locale) {
    $url = $this->getItemsUrlForPackId($packId, $locale);
    $this->log("Downloading items [".$locale."] for pack [".$packId."] from ".$url);
    $items = $this->downloadFile($url);
    file_put_contents($this->getItemsPathForPackId($packId, $locale), $items);
    $items = json_decode($items);
    if (is_array($items))
      foreach ($items as $item) {
        if (isset($item->item))
          $item = $item->item;
        if (!$this->imgsDone) {
          $this->downloadItemImage($item->identity, $item->first_image_url, 'first_image');
          $this->downloadItemImage($item->identity, $item->second_image_url, 'second_image');
        }
      }
    $this->log("Done items [".$locale."] for pack [".$packId."]");
  }

  public function download() {
    $this->log("Downloading locales [".implode(',', $this->locales)."], base packs [".implode(',', $this->basePackIds)."]");
    foreach ($this->locales as $locale) {
      $this->downloadTags($locale);
      $packIds = $this->downloadPacks($locale);
      foreach ($packIds as $packId)
        $this->downloadItemsForPackId($packId, $locale);
      $this->imgsDone = TRUE;
    }
    $this->log("ALL DONE");
  }
}

$dl = new SeedJSONDownloader();
$dl->setLocales(array('en', 'fr', 'es'));
$dl->setBaseUrl("https://playboy-preprod.chugulu.com");
$dl->setBasePackIds(array(450));
$dl->download();

?>